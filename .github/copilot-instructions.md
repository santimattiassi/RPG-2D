# Copilot instructions for RanaMinas

- This is a static single-page browser game stored in `ranaminas_el_templo_perdido.html`.
- There is no build system, package manager, or tests. The main workflow is edit + open in browser (or use a simple local file server).
- The page uses CDN libraries only: Tailwind CSS, Google Fonts, and Phosphor icons. Do not add Node-specific bundling assumptions.

## Key structure
- UI layout is defined in HTML and wired by `id` values such as `game-canvas`, `frog-name-input`, `caminito-container`, `shop-items`, `inventory-grid`, `game-overlay`, `level-display`, `progress-display`, `gold-display`, and `hearts-container`.
- Game logic is inline in the `<script>` at the bottom of the same file.
- Global state is stored in variables like `grid`, `frog`, `shopInventory`, `gameState`, `gold`, `lives`, and `currentBiomeIndex`.
- `BIOMES` is the theme palette and image source list for the six levels; images live under `img/` and are referenced by `BIOMES[].imageSrc`.

## Important behavior
- First click creates a safe board via `generateBoard(firstClickedCol, firstClickedRow)`; the first clicked cell is always safe.
- Movement uses BFS pathfinding in `calculatePath()` and only travels over visited tiles or the final destination cell.
- Rendering is driven by `renderLoop()` with `requestAnimationFrame`; visual state, particles, and canvas drawing are all updated there.
- Mouse and input handlers are on the canvas: click for move/explore, right-click for flagging, space toggles `activeTool`, and item selection uses `shopInventory` state.

## Project-specific patterns
- Minesweeper-like game board with custom roguelike mechanics:
  - `grid[c][r]` tiles contain `isMine`, `isHeart`, `isCoin`, `neighborMines`, `visited`, `flagged`, `exploded`, and collected flags.
  - `useScannerItem()` reveals a 3x3 area and auto-collects coins/hearts.
  - `useJumpItem()` teleports the frog to a nearby safe tile.
- The shop items are hard-coded in `shopInventory`; item state is updated by `buyShopItem()`, `selectInventoryItem()`, `updateShopUI()`, and `updateInventoryUI()`.
- UI updates are explicit, not data-bound. Always call the relevant updater after changing state (for example `updateProgressUI()`, `updateHeartsUI()`, `updateShopUI()`, `updateInventoryUI()`, `updateLevelMapUI()`).
- The game is Spanish-language oriented; preserve existing text and voice tone when changing labels or messages.

## When editing
- Keep DOM ids and event wiring intact unless refactoring across the file.
- Preserve inline canvas drawing logic if changing visuals; it is intentionally handcrafted in functions like `drawFrogHero()`, `drawNumberIndicator()`, `drawExplodedMine()`, and `drawBgCover()`.
- If you change the board size or cell dimensions, update the constants near `cols`, `rows`, `cellSize`, `startX`, and `startY` together.
- Do not assume modern JS module infrastructure; this file runs as a plain browser script.

## Run and verify
- Open `ranaminas_el_templo_perdido.html` in a browser.
- Confirm the initial name modal appears, the first click spawns the frog, the shop updates gold, and right-click toggles flags.
- Verify `img/` assets load correctly for each biome theme.

If any part of the game state or event flow is unclear, I can refine the instructions further.