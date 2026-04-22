# Changelog

## Unreleased
- Scaffold initial Godot 4 project structure (scenes, scripts, data directories)
- Add AGENTS.md with Claude Code working rules
- Add GDD.md (game design document)
- Implement `GameState` singleton (gold, cargo, upgrades, ledger)
- Implement `Economy` singleton (deterministic hourly prices + next-hour forecasts)
- Implement `VoyageManager` singleton (timestamp-based dispatch, weighted event resolution)
- Implement `SaveLoad` singleton (JSON persistence via FileAccess)
- Implement `MainMenu` scene with voyage resolution on open
- Implement `PortMarket` scene with buy/sell UI and forecast display
- Implement `WorldMap` scene with voyage dispatch
- Implement `UpgradeShop` scene (hull, sails, first mate)
- Implement `Ledger` scene (voyage history)
- Add data files: ports.json, goods.json, events.json
