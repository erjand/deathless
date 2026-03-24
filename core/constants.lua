local Deathless = Deathless

Deathless.Constants = Deathless.Constants or {}

Deathless.Constants.Metadata = {
    ADDON_NAME = "Deathless",
    VERSION = "0.6.6",
}

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
        SectionHeader = {
            bgAlpha = 0.4,
            hoverAlpha = 0.6,
            height = 28,
            iconOffsetX = 8,
            labelOffsetX = 6,
        },
        ScrollIndicator = {
            fadeDelay = 1.0,
            fadeSpeed = 5,
            thumbAlpha = 0.7,
            thumbDefaultHeight = 20,
            thumbMinHeight = 12,
            trackWidth = 3,
            wheelStep = 40,
            smoothSpeed = 0.25,
            smoothThreshold = 0.5,
        },
        Row = {
            stripeAlpha = 0.2,
            expandedAlpha = 0.4,
        },
        Icon = {
            alphaNormal = 1,
            alphaMuted = 0.8,
            alphaDimmed = 0.6,
            alphaFaded = 0.5,
            alphaDisabled = 0.55,
            sizeTiny = 14,
            sizeSmall = 16,
            sizeMedium = 18,
            sizeLarge = 20,
        },
        Controls = {
            checkbox = {
                borderInset = 1,
                boxSize = 14,
                checkInset = 1,
                controlHeight = 20,
                labelGap = 6,
            },
            search = {
                clearButtonOffsetX = -2,
                clearButtonSize = 16,
                defaultMaxLetters = 50,
                defaultWidth = 180,
                height = 20,
                labelOffsetX = 2,
                labelOffsetY = 2,
                textInsetLeft = 4,
                textInsetRight = 20,
            },
        },
        TableLayouts = {
            Abilities = {
                rowHeight = 26,
                columns = {
                    name = { x = 36, w = 200 },
                    level = { x = 250, w = 50 },
                    cost = { x = 310, w = 80 },
                    source = { x = 400, w = 60 },
                    train = { x = 470, w = 50 },
                },
                row = {
                    iconX = 16,
                    iconSize = 18,
                    nameWidth = 190,
                },
            },
            Gear = {
                iconSize = 18,
                iconPad = 4,
                scrollInset = 8,
                columns = {
                    name = { x = 16, w = 190 },
                    type = { x = 210, w = 65 },
                    lvl = { x = 280, w = 36 },
                    source = { x = 322, w = 170 },
                    prebis = { x = 496, w = 64 },
                },
            },
            Stats = {
                headerXShift = 0,
                statRowHeight = 44,
                combatRowHeight = 24,
                primary = {
                    stat = { x = 16, w = 90 },
                    bonus = { x = 112, w = 190 },
                    priority = { x = 308, w = 66 },
                    note = { x = 380, w = 168 },
                },
                hit = {
                    weaponSkill = { x = 16, w = 80 },
                    enemyLevel = { x = 102, w = 70 },
                    hand = { x = 178, w = 62 },
                    hit = { x = 246, w = 45 },
                    crit = { x = 297, w = 45 },
                    miss = { x = 348, w = 45 },
                    dodge = { x = 399, w = 55 },
                    parry = { x = 460, w = 55 },
                },
                defense = {
                    defense = { x = 16, w = 65 },
                    characterLevel = { x = 87, w = 78 },
                    attackerLevel = { x = 171, w = 78 },
                    hit = { x = 255, w = 55 },
                    crit = { x = 316, w = 55 },
                    crushing = { x = 377, w = 90 },
                },
            },
            Dungeons = {
                rowHeight = 26,
                main = {
                    expand = { x = 4 },
                    level = { x = 16, w = 50 },
                    name = { x = 75, w = 170 },
                    zone = { x = 250, w = 130 },
                    boss = { x = 390, w = 190 },
                },
                quests = {
                    rowHeight = 20,
                    headerHeight = 16,
                    maxRewardIcons = 5,
                    iconSize = 18,
                    iconSpacing = 2,
                    columns = {
                        name = { x = 28, w = 210 },
                        level = { x = 243, w = 30 },
                        startedBy = { x = 278, w = 150 },
                        prereq = { x = 423, w = 45 },
                        rewards = { x = 475, w = 80 },
                    },
                },
            },
        },
        ViewOffsets = {
            defaultScrollBottom = 24,
            simple = {
                scrollTop = -60,
            },
            classSimple = {
                scrollTopEmbedded = -10,
                scrollTopFull = -60,
            },
            classTalents = {
                scrollTopEmbedded = -10,
                scrollTopFull = -70,
            },
            classSearch = {
                searchYEmbedded = -16,
                searchYFull = -60,
                sortHeaderYEmbedded = -59,
                sortHeaderYFull = -103,
                scrollTopEmbedded = -79,
                scrollTopFull = -123,
            },
            classGearSearch = {
                searchYEmbedded = -16,
                searchYFull = -52,
                sortHeaderYEmbedded = -59,
                sortHeaderYFull = -95,
                scrollTopEmbedded = -79,
                scrollTopFull = -115,
            },
            dungeons = {
                searchY = -68,
                sortHeaderY = -111,
                scrollTop = -131,
            },
        },
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
    AMMO = "ammo",
    BANDAGES = "bandages",
    CLASS_REAGENTS = "classReagents",
    ENGINEERING = "engineering",
    FLASKS = "flasks",
    HEALTH_POTIONS = "healthPotions",
    HEARTHSTONE = "hearthstone",
    LIP = "lip",
    MAGE_CONJURES = "mageConjures",
    MANA_POTIONS = "manaPotions",
    QUESTS = "quests",
    SWIFTNESS_POTIONS = "swiftnessPotions",
    TALENTS = "talents",
}

Deathless.Constants.MiniSections = {
    WARNINGS = "warnings",
    XP_PROGRESS = "xpProgress",
    AVAILABLE = "available",
    NEXT_AVAILABLE = "nextAvailable",
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

Deathless.Constants.Factions = {
    ALLIANCE = "Alliance",
    HORDE = "Horde",
    BOTH = "Both",
}

Deathless.Constants.Urls = {
    WOWHEAD_CLASSIC_ITEM_BASE = "https://www.wowhead.com/classic/item=",
    WOWHEAD_CLASSIC_NPC_BASE = "https://www.wowhead.com/classic/npc=",
    WOWHEAD_CLASSIC_QUEST_BASE = "https://www.wowhead.com/classic/quest=",
}

Deathless.Constants.Ammo = {
    LOW_THRESHOLD_MELEE = 20,
    WARNING_MIN_LEVEL = 10,
    WARNING_MIN_LEVEL_MELEE = 10,
    SLOT_TOKENS = {
        LEGACY_RANGED = "RangedSlot",
        RANGED = "RANGEDSLOT",
    },
    SLOT_IDS = {
        RANGED = 18,
    },
    RangedWeaponSubclassIds = {
        THROWN = 16,
    },
}
