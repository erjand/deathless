# deathless

## Overview

A Hardcore Classic WoW addon.

`deathless` is a multi-purpose / AIO companion addon for the HC player on their 1-60 journey. 

It tries to provide recommendations and best practices to the player by being opinionated but not obnoxious or unnecessarily 
prescriptive. "What is the generally regarded community of the HC community about `x`" instead of "What is my hot take about `x`".

1. Replace `RestedXP` or other leveling guides with a more high-level and generalized flow through leveling without being overly hand-holding.
2. Replace the need for `WeakAuras` or other tools to show warnings when important buffs or items are missing.
3. Reduce / eliminate the need for 3rd-party references for quests, talents, abilities, zones, dungeons, and professions.

### Key Capabilities

- Class guides, ability lists, talent builds, and gear
- Dungeon guides and quest rewards
- Leveling quests and suggested routes
- Profession guides
- Self-found information and guide
- Zone overview, hot spots, and important quests

## Getting Started Without an Addon Manager

1. Clone the repo
2. If your WoW installation is in the standard location (`C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns`), and you are on Windows, run `scripts\deploy.bat`. You will likely have to give Admin permission to the script to run.
    1. If your WoW installation is not in the standard location, manually copy the `deathless` directory to your `\Addons\` directory; or update the `scripts\deploy.ps1` script for your path.
    2. If you are not on Windows, then manually move the addon files or write your own shell script.
3. Run the addon in game with the command `/deathless` or `/dls`. Run `/dls h` in-game for all available commands.
4. When making changes, run `scripts\deploy.bat` again, then `/reload` in game.

## Data Source Workflow

Data should be maintained in CSV and generated into Lua:

- Source CSV: `data/source/*.csv`
- Generated Lua: `data/gear/*.lua`
- Generator script: `scripts/generate-all-csv.bat`

## Versioning

- Use SemVer
- When updating the version, ensure that `deathless.toc` and `core/constants.lua` always match:

## Features 

### Detailed Class Information

#### Abilities

> Currently 100% implemented

- Shows Abilities for each class: Learned, Available, Next Available, and Unavailable.
- Includes level available, price, source, and a recommendation as to train, wait to train, or not train each ability.

#### Gear

> Heavily in progress

- Shows notable gear for leveling, Pre-BiS, and Raids

#### Talents

> Currently 100% implemented

- Shows at least one generally viable HC leveling talent tree for each class

### Dungeons

> Currently implemented for top-level table but not yet all individual dungeons

- Shows overview of all dungeons and their appropriate level ranges
- For each dungeon, provides a brief Warnings section for notable dangers
- For each dungeon, provides a full list of available quests, and their rewards

### Summary Tab / Mini Viewer

> 100% implemented

- Displays dynamic Warnings to the player for things like: missing health potions, unspent Talent points, or under-leveled First Aid
- Available in the `Summary` tab in the main addon, or as a mini viewer

