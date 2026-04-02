param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot

function ConvertTo-BoolFlag {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber,
        [string]$FieldName,
        [bool]$DefaultValue = $false
    )

    if (-not ($Row.PSObject.Properties.Name -contains $FieldName)) { return $DefaultValue }
    $rawValue = "$($Row.$FieldName)".Trim().ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($rawValue)) { return $DefaultValue }
    if ($rawValue -in @("1", "true", "yes", "y")) { return $true }
    if ($rawValue -in @("0", "false", "no", "n")) { return $false }
    throw "Row ${RowNumber}: invalid $FieldName value '$rawValue'. Allowed: true/false, 1/0, yes/no, y/n, or empty."
}

function ConvertTo-LuaString {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return $Value.Replace("\", "\\").Replace('"', '\"')
}

function Test-RequiredField {
    param([pscustomobject]$Row, [int]$RowNumber, [string]$FieldName)
    $raw = $Row.$FieldName
    if ($null -eq $raw -or [string]::IsNullOrWhiteSpace("$raw")) {
        throw "Row ${RowNumber}: missing required field '$FieldName'."
    }
}

function Get-IntField {
    param([pscustomobject]$Row, [int]$RowNumber, [string]$FieldName)
    $value = "$($Row.$FieldName)".Trim()
    $parsed = 0
    if (-not [int]::TryParse($value, [ref]$parsed)) {
        throw "Row ${RowNumber}: field '$FieldName' must be an integer (received '$value')."
    }
    return $parsed
}

function Get-ClassesList {
    param([pscustomobject]$Row, [int]$RowNumber)
    $classes = @()
    $classColumns = [ordered]@{
        warrior = "Warrior"
        paladin = "Paladin"
        hunter = "Hunter"
        rogue = "Rogue"
        priest = "Priest"
        mage = "Mage"
        warlock = "Warlock"
        druid = "Druid"
        shaman = "Shaman"
    }
    foreach ($entry in $classColumns.GetEnumerator()) {
        if (ConvertTo-BoolFlag -Row $Row -RowNumber $RowNumber -FieldName $entry.Key -DefaultValue $false) {
            $classes += $entry.Value
        }
    }
    if ($classes.Count -eq 0) {
        throw "Row ${RowNumber}: at least one class column must be true."
    }
    return $classes
}

function Get-Tiers {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber
    )

    $isPreBis = ConvertTo-BoolFlag -Row $Row -RowNumber $RowNumber -FieldName "pre_bis" -DefaultValue $false
    $hasLevelingColumn = $Row.PSObject.Properties.Name -contains "leveling"
    $isLeveling = ConvertTo-BoolFlag -Row $Row -RowNumber $RowNumber -FieldName "leveling" -DefaultValue $false

    if ($hasLevelingColumn) {
        if ($isLeveling -and $isPreBis) { return @("Leveling", "Pre-BiS") }
        if ($isLeveling) { return @("Leveling") }
        if ($isPreBis) { return @("Pre-BiS") }
        return @()
    }

    if ($isPreBis) { return @("Pre-BiS") }
    return @("Leveling")
}

function New-ArmorSlotData {
    param(
        [string]$SlotName,
        [string]$CsvFileName,
        [string]$LuaFileName,
        [string]$TableName
    )

    $csvPath = Join-Path $RepoRoot ("data/source/" + $CsvFileName)
    $outputPath = Join-Path $RepoRoot ("data/gear/" + $LuaFileName)

    if (-not (Test-Path -LiteralPath $csvPath)) {
        throw "CSV not found: $csvPath"
    }

    $rows = @(Import-Csv -LiteralPath $csvPath)
    if ($rows.Count -eq 0) {
        throw "CSV has no data rows: $csvPath"
    }

    $allowedRarities = @("poor", "common", "uncommon", "rare", "epic", "legendary")
    $allowedFactions = @("Alliance", "Horde")
    $lines = New-Object System.Collections.Generic.List[string]

    $lines.Add("local Deathless = Deathless")
    $lines.Add("")
    $lines.Add("Deathless.Data = Deathless.Data or {}")
    $lines.Add("Deathless.Data.Gear = Deathless.Data.Gear or {}")
    $lines.Add("")
    $lines.Add('-- Source format: "{Dungeon} - {Boss}", "Quest - {Name}", "{Profession} ({Detail})", "Reputation - {Faction} ({Level})", "World Drop", "Vendor"')
    $lines.Add("-- GENERATED FROM data/source/$CsvFileName. DO NOT EDIT MANUALLY.")
    $lines.Add("")
    $lines.Add("Deathless.Data.Gear.$TableName = {")

    $rowNumber = 1
    foreach ($row in $rows) {
        $rowNumber++
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "name"
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "type"
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "levelReq"
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "source"
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "rarity"
        Test-RequiredField -Row $row -RowNumber $rowNumber -FieldName "itemId"

        $name = ConvertTo-LuaString "$($row.name)".Trim()
        $type = ConvertTo-LuaString "$($row.type)".Trim()
        $levelReq = Get-IntField -Row $row -RowNumber $rowNumber -FieldName "levelReq"
        $source = ConvertTo-LuaString "$($row.source)".Trim()
        $rarity = "$($row.rarity)".Trim().ToLowerInvariant()
        $itemId = Get-IntField -Row $row -RowNumber $rowNumber -FieldName "itemId"
        $classes = Get-ClassesList -Row $row -RowNumber $rowNumber
        $tiers = @(Get-Tiers -Row $row -RowNumber $rowNumber)
        $faction = "$($row.faction)".Trim()

        if ($allowedRarities -notcontains $rarity) {
            throw "Row ${rowNumber}: invalid rarity '$rarity'. Allowed: $($allowedRarities -join ', ')."
        }
        if (-not [string]::IsNullOrWhiteSpace($faction) -and ($allowedFactions -notcontains $faction)) {
            throw "Row ${rowNumber}: invalid faction '$faction'. Allowed: Alliance, Horde, or empty."
        }

        $classValues = $classes | ForEach-Object { "`"$(ConvertTo-LuaString $_)`"" }
        $classList = "{ " + ($classValues -join ", ") + " }"

        $itemFields = @(
            "name = `"$name`"",
            "slot = `"$SlotName`"",
            "type = `"$type`"",
            "levelReq = $levelReq",
            "source = `"$source`"",
            "rarity = `"$rarity`"",
            "itemId = $itemId"
        )

        if ($tiers.Count -gt 0) {
            $tierValues = $tiers | ForEach-Object { "`"$(ConvertTo-LuaString $_)`"" }
            $itemFields += "tiers = { " + ($tierValues -join ", ") + " }"
        }
        $itemFields += "classes = $classList"
        if (-not [string]::IsNullOrWhiteSpace($faction)) {
            $itemFields += "faction = `"$(ConvertTo-LuaString $faction)`""
        }

        $lines.Add("    { " + ($itemFields -join ", ") + " },")
    }

    $lines.Add("}")
    $lines.Add("")

    [System.IO.File]::WriteAllText($outputPath, ($lines -join "`n"), [System.Text.UTF8Encoding]::new($false))
    Write-Host "Generated $outputPath from $csvPath"
}

$slotConfigs = @(
    @{ Slot = "Head";      Csv = "armor_head.csv";      Lua = "armor_head.lua";      Table = "ArmorHead" },
    @{ Slot = "Shoulders"; Csv = "armor_shoulders.csv"; Lua = "armor_shoulders.lua"; Table = "ArmorShoulders" },
    @{ Slot = "Chest";     Csv = "armor_chest.csv";     Lua = "armor_chest.lua";     Table = "ArmorChest" },
    @{ Slot = "Wrist";     Csv = "armor_wrist.csv";     Lua = "armor_wrist.lua";     Table = "ArmorWrist" },
    @{ Slot = "Hands";     Csv = "armor_hands.csv";     Lua = "armor_hands.lua";     Table = "ArmorHands" },
    @{ Slot = "Waist";     Csv = "armor_waist.csv";     Lua = "armor_waist.lua";     Table = "ArmorWaist" },
    @{ Slot = "Legs";      Csv = "armor_legs.csv";      Lua = "armor_legs.lua";      Table = "ArmorLegs" },
    @{ Slot = "Feet";      Csv = "armor_feet.csv";      Lua = "armor_feet.lua";      Table = "ArmorFeet" }
)

foreach ($cfg in $slotConfigs) {
    New-ArmorSlotData -SlotName $cfg.Slot -CsvFileName $cfg.Csv -LuaFileName $cfg.Lua -TableName $cfg.Table
}
