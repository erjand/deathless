local Deathless = Deathless

Deathless.Constants = Deathless.Constants or {}

Deathless.Constants.Colors = {
    Codes = {
        enemy = "|cffcc4d4d",
        moneyCopper = "|cffb87333",
        moneyGold = "|cffffd700",
        moneySilver = "|cffc0c0c0",
        safe = "|cff66cc66",
        warning = "|cffffcc33",
    },
    AbilitySection = {
        learned = { 0.5, 0.5, 0.5 },
        nextAvailable = { 0.5, 0.7, 0.9 },
        unavailable = { 0.6, 0.4, 0.4 },
    },
    Class = {
        druid = { 1.00, 0.49, 0.04 },
        hunter = { 0.67, 0.83, 0.45 },
        mage = { 0.25, 0.78, 0.92 },
        paladin = { 0.96, 0.55, 0.73 },
        priest = { 1.00, 1.00, 1.00 },
        rogue = { 1.00, 0.96, 0.41 },
        shaman = { 0.00, 0.44, 0.87 },
        warlock = { 0.53, 0.53, 0.93 },
        warrior = { 0.78, 0.61, 0.43 },
    },
    Dungeon = {
        quest = { 0.5, 0.7, 0.9 },
    },
    GearSection = {
        armor = { 0.50, 0.70, 0.90 },
        misc = { 0.75, 0.60, 0.85 },
        ranged = { 0.70, 0.80, 0.60 },
        shields = { 0.72, 0.72, 0.78 },
        weapons = { 0.90, 0.65, 0.35 },
    },
    ItemRarity = {
        common = { 1.00, 1.00, 1.00 },
        epic = { 0.64, 0.21, 0.93 },
        legendary = { 1.00, 0.50, 0.00 },
        poor = { 0.62, 0.62, 0.62 },
        rare = { 0.00, 0.44, 0.87 },
        uncommon = { 0.12, 1.00, 0.00 },
    },
    UI = {
        accent = { 0.4, 0.8, 0.4, 1 },
        bg = { 0.08, 0.08, 0.10, 0.95 },
        bgLight = { 0.12, 0.12, 0.14, 1 },
        border = { 0.3, 0.3, 0.35, 1 },
        borderLight = { 0.4, 0.4, 0.45, 1 },
        danger = { 0.8, 0.3, 0.3, 1 },
        diffGray = { 0.6, 0.6, 0.6 },
        diffGreen = { 0.4, 0.8, 0.4 },
        diffOrange = { 1.0, 0.5, 0.25 },
        diffRed = { 0.8, 0.3, 0.3 },
        diffYellow = { 1.0, 0.8, 0.2 },
        dividerFaint = { 1, 1, 1, 0.08 },
        hover = { 0.18, 0.18, 0.20, 1 },
        info = { 0.5, 0.8, 1.0, 1 },
        orange = { 1.0, 0.5, 0.25 },
        red = { 0.8, 0.3, 0.3, 1 },
        success = { 0.5, 1, 0.5, 1 },
        text = { 0.9, 0.9, 0.9, 1 },
        textDim = { 0.6, 0.6, 0.6, 1 },
        tooltipText = { 0.8, 0.8, 0.8, 1 },
        transparent = { 0, 0, 0, 0 },
        warningHover = { 1, 0.9, 0.4, 1 },
        white = { 1, 1, 1, 1 },
        white60 = { 1, 1, 1, 0.6 },
        xpHeader = { 0.4, 0.8, 1.0, 1 },
        xpHeaderHover = { 0.5, 0.9, 1.0, 1 },
        xpNext = { 0.5, 0.7, 0.9, 1 },
        xpNextHover = { 0.6, 0.8, 1.0, 1 },
        xpProgress = { 0.58, 0.0, 0.55, 0.8 },
        xpRested = { 0.0, 0.39, 0.88, 0.8 },
        xpTrackBg = { 0.1, 0.1, 0.1, 0.8 },
        yellow = { 1.0, 0.8, 0.2 },
    },
}

Deathless.Constants.Fonts = {
    -- Font families
    family = "Fonts\\FRIZQT__.TTF",
    icons = "Fonts\\ARIALN.TTF", -- For arrows/icons (has Unicode support)
    code = _G["STANDARD_TEXT_FONT"] or "Fonts\\ARIALN.TTF", -- Locale-aware client font for copy/code text

    -- Size presets
    titleLarge = 23,
    title = 19,
    header = 13,
    sectionHeader = 12,
    subtitle = 11,
    body = 10,
    small = 9,
    tiny = 8,
}

Deathless.Constants.GearTiers = {
    LEVELING = "Leveling",
    PRE_BIS = "Pre-BiS",
}

Deathless.Constants.WarningCategories = {
    BANDAGES = "bandages",
    CLASS_REAGENTS = "classReagents",
    ENGINEERING = "engineering",
    FLASKS = "flasks",
    HEALTH_POTIONS = "healthPotions",
    HEARTHSTONE = "hearthstone",
    LIP = "lip",
    LOW_EQUIPPED_AMMO = "lowEquippedAmmo",
    MAGE_CONJURES = "mageConjures",
    MANA_POTIONS = "manaPotions",
    MISSING_EQUIPPED_AMMO = "missingEquippedAmmo",
    QUESTS = "quests",
    SWIFTNESS_POTIONS = "swiftnessPotions",
    TALENTS = "talents",
}

Deathless.Constants.ClassIds = {
    HUNTER = "HUNTER",
    MAGE = "MAGE",
    PALADIN = "PALADIN",
    PRIEST = "PRIEST",
    ROGUE = "ROGUE",
    WARLOCK = "WARLOCK",
    WARRIOR = "WARRIOR",
}

Deathless.Constants.Ammo = {
    LOW_THRESHOLD_HUNTER = 200,
    LOW_THRESHOLD_MELEE = 20,
    WARNING_MIN_LEVEL = 10,
}
