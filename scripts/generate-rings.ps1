param(
    [string]$CsvPath = "data/source/rings.csv",
    [string]$OutputPath = "data/gear/rings.lua"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot

if (-not [System.IO.Path]::IsPathRooted($CsvPath)) {
    $CsvPath = Join-Path $RepoRoot $CsvPath
}

if (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $RepoRoot $OutputPath
}

function ConvertTo-BoolFlag {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber,
        [string]$FieldName,
        [bool]$DefaultValue = $false
    )

    if (-not ($Row.PSObject.Properties.Name -contains $FieldName)) {
        return $DefaultValue
    }

    $rawValue = "$($Row.$FieldName)".Trim().ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($rawValue)) {
        return $DefaultValue
    }

    if ($rawValue -in @("1", "true", "yes", "y")) {
        return $true
    }

    if ($rawValue -in @("0", "false", "no", "n")) {
        return $false
    }

    throw "Row ${RowNumber}: invalid $FieldName value '$rawValue'. Allowed: true/false, 1/0, yes/no, y/n, or empty."
}

function ConvertTo-LuaString {
    param([string]$Value)

    if ($null -eq $Value) {
        return ""
    }

    return $Value.Replace("\", "\\").Replace('"', '\"')
}

function Test-RequiredField {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber,
        [string]$FieldName
    )

    $raw = $Row.$FieldName
    if ($null -eq $raw -or [string]::IsNullOrWhiteSpace("$raw")) {
        throw "Row ${RowNumber}: missing required field '$FieldName'."
    }
}

function Get-IntField {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber,
        [string]$FieldName
    )

    $value = "$($Row.$FieldName)".Trim()
    $parsed = 0
    if (-not [int]::TryParse($value, [ref]$parsed)) {
        throw "Row ${RowNumber}: field '$FieldName' must be an integer (received '$value')."
    }

    return $parsed
}

function Get-ClassesList {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber
    )

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

function Get-PreBisFlag {
    param(
        [pscustomobject]$Row,
        [int]$RowNumber
    )

    return ConvertTo-BoolFlag -Row $Row -RowNumber $RowNumber -FieldName "pre_bis" -DefaultValue $false
}

if (-not (Test-Path -LiteralPath $CsvPath)) {
    throw "CSV not found: $CsvPath"
}

$rows = @(Import-Csv -LiteralPath $CsvPath)
if ($rows.Count -eq 0) {
    throw "CSV has no data rows: $CsvPath"
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
$lines.Add("-- GENERATED FROM data/source/rings.csv. DO NOT EDIT MANUALLY.")
$lines.Add("")
$lines.Add("Deathless.Data.Gear.Rings = {")

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
    $isPreBis = Get-PreBisFlag -Row $row -RowNumber $rowNumber
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
        "slot = `"Ring`"",
        "type = `"$type`"",
        "levelReq = $levelReq",
        "source = `"$source`"",
        "rarity = `"$rarity`"",
        "itemId = $itemId"
    )

    if ($isPreBis) {
        $itemFields += "tiers = { `"Pre-BiS`" }"
    }

    $itemFields += "classes = $classList"

    if (-not [string]::IsNullOrWhiteSpace($faction)) {
        $itemFields += "faction = `"$(ConvertTo-LuaString $faction)`""
    }

    $line = "    { " + ($itemFields -join ", ") + " },"
    $lines.Add($line)
}

$lines.Add("}")
$lines.Add("")

$outputDirectory = Split-Path -Path $OutputPath -Parent
if (-not [string]::IsNullOrWhiteSpace($outputDirectory) -and -not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

[System.IO.File]::WriteAllText($OutputPath, ($lines -join "`n"), [System.Text.UTF8Encoding]::new($false))
Write-Host "Generated $OutputPath from $CsvPath"
