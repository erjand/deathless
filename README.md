# deathless

## Overview

A Hardcore Classic WoW addon.

`deathless` is an opinionated multi-purpose / AIO companion addon for the HC player on their 1-60 journey. 

### Key Capabilities

- Class guides, ability lists, talent builds, and important gear
- Dungeon guides
- Leveling quests and suggested routes
- Profession guides
- Self-found information and guide
- Zone overview, hot spots, and important quests

### Philosophy

1. Appropriately Opinionated: Try to provide recommendations and best practices to the player by being opinionated but not obnoxious or unnecessarily prescriptive. "What is the generally regarded community of the HC community about `x`" vs "What is my hot take about `x`".
2. Reduce / eliminate the need for 3rd-party references. We we want to make it easier to stay in-game vs checking Wowhead, Discord, spreadsheets, etc.

## Getting Started

1. Clone the repo
2. If your WoW installation is in the standard location (`C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns`), and you are on Windows, run `deploy.bat`. 
    1. If your WoW installation is not in the standard location, manually copy the `deathless` directory to our `\Addons\` directory; or update the `deploy.ps1` script for your path.
    2. If you are not on Windows, then manually move the addon files or write your own shell script.
3. Run the addon in game with the command `/deathless` or `/dls`. Check `core/commands.lua` for all available commands.
4. When making changes, run `deploy.bat` again, then `/reload` in game.

## Features 

### Abilities

> Currently 100% implemented for Warrior, Priest, and Mage. Other classes are WIP / stubs

- Shows Abilities for each class: Learned, Available, Next Available, and Unavailable.
- Includes level available, price, source, and a recommendation as to train, wait to train, or not train each ability.
