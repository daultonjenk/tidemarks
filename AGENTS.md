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


## Art Direction For V0.1 — Geometric Flat
- The target aesthetic is Geometric Flat. Dark background, solid filled shapes, no outlines, no gradients, no textures. Color alone carries all the visual weight.
- The SVG snippet below is the canonical reference. When in doubt about how something should look, come back to this. Match this energy.

<svg viewBox="0 0 320 200" xmlns="http://www.w3.org/2000/svg">

  <!-- Background -->
  <rect width="320" height="200" fill="#1a1a2e" />

  <!-- Ground / floor -->
  <rect x="0" y="160" width="320" height="40" fill="#16213e" />

  <!-- Platform — subtle, darker than bg, no outline -->
  <rect x="60" y="130" width="80" height="12" fill="#0f3460" />

  <!-- Player — triangle, bright accent, no outline -->
  <!-- Pointing right by default. Rotate to face cursor at runtime. -->
  <polygon points="85,98 107,114 85,130" fill="#e94560" />

  <!-- Basic enemy — circle, warm contrast color, no outline -->
  <circle cx="228" cy="98" r="13" fill="#f5a623" />

  <!-- Collectible / point of interest — small, high contrast -->
  <rect x="265" y="90" width="10" height="10" fill="#00d4ff" rx="1" />

  <!-- Hazard — dark, recessive, still readable -->
  <polygon points="140,160 150,140 160,160" fill="#533483" />

</svg>
