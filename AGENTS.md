# Tidemarks — Claude Code Working Rules

## Engine & Language
- Godot 4 only. GDScript only. No C#, no C++, no external libraries.
- No physics systems. This is a UI/menu-driven game with no spatial simulation.

## Architecture
- All persistent game state lives in Singletons (Autoloads): `GameState`, `Economy`, `VoyageManager`, `SaveLoad`.
- Do not store game state in scene scripts. Scene scripts read from and write to singletons only.
- Scenes are responsible only for display and user input.

## Economy & Time
- Prices update on real-world device clock — one tick per hour, keyed to wall-clock hour.
- Use `Time.get_unix_time_from_system()` for all time operations. Never use Godot's scene timers for economy or voyage logic.
- Voyage travel is timestamp-based: store Unix departure time and computed arrival time, resolve on app open.
- Price calculation must be deterministic: same port + good + hour always yields the same price (use seeded RNG with `hash(good_id + port_id + str(hour))`).

## Save System
- Save format: JSON via Godot's `FileAccess`.
- Save path: `user://tidemarks_save.json`.
- Call `SaveLoad.save_game()` after every state-changing player action.

## Art & Assets
- Placeholder art only in V1. `ColorRect` and `Label` nodes are fully acceptable.
- Do not import or reference external image assets unless explicitly requested.
- All UI must be functional on a 360×800 portrait mobile screen.

## Changelog
- Update `CHANGELOG.md` after every meaningful change.
- Format: add a bullet under `## Unreleased` describing what changed.
