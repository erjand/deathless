# Contributing to Deathless

## Local Development

### Getting Started

1. Clone the repo
2. If your WoW installation is in the standard location (`C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns`), and you are on Windows, run `scripts\deploy.bat`. You will likely have to give Admin permission to the script to run.
    1. If your WoW installation is not in the standard location, manually copy the `deathless` directory to your `\Addons\` directory; or update the `scripts\deploy.ps1` script for your path.
    2. If you are not on Windows, then manually move the addon files or write your own shell script.
3. Run the addon in game with the command `/deathless` or `/dls`. Run `/dls h` in-game for all available commands.
4. When making changes, run `scripts\deploy.bat` again, then `/reload` in game.

### Embedded libraries (minimap button)

Deathless uses these libraries for the LibDataBroker minimap icon:

- **LibStub** — library versioning stub
- **CallbackHandler-1.0** — used by LibDataBroker
- **LibDataBroker-1.1** — data object API for the minimap launcher
- **LibDBIcon-1.0** — minimap button UI

**Releases:** The [BigWigs packager](https://github.com/BigWigsMods/packager) pulls them from CurseForge SVN via `.pkgmeta` `externals` into `libs/` when building a release zip. You do not commit the downloaded library files.

**Local development:** Run `scripts\fetch-libs.bat` (or `scripts\fetch-libs.ps1`) once after cloning, and again when you want to refresh those files. That downloads the same sources the packager uses into `libs/`. Only `libs/libs.xml` is tracked in git; the `libs/*/` folders are ignored so each machine keeps its own copies.

`scripts\deploy.ps1` copies the `libs` folder into the dev addon install, so fetch libs before deploying if you need the minimap button locally.

### Data Source Workflow

Data should be maintained in CSV and generated into Lua:

- Source CSV: `data/source/*.csv`
- Generated Lua: `data/gear/*.lua`
- Generator script: `scripts/generate-all-csv.bat`

### Versioning

- Use SemVer
- Versions are managed automatically via git tags and the [BigWigs packager](https://github.com/BigWigsMods/packager) (`@project-version@` token replacement)

```shell
git add .
git commit -m "1.0.0 release"
git tag -a v1.0.0 -m "1.0.0 release"
git push --follow-tags
```
