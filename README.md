# Linagora Design Flutter — Automated Figma Sync Pipeline

Automated pipeline that keeps a Flutter design system package (`linagora_design_flutter`) in sync with its Figma source of truth. New components are discovered, widgets are generated, and design drift is detected — all without manual intervention.

## Stats

| Metric | Value |
|--------|-------|
| Figma components mapped | 42 |
| Flutter widgets generated | 40 |
| Golden test files | 40 (267 test cases) |
| Widgetbook use cases | 42 components, 79 use cases |
| Golden reference images | 208 PNGs |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Figma REST API                               │
│              (source of truth for design)                       │
└──────────┬──────────────────────────────────────────────────────┘
           │
           │  Nightly cron (2am UTC) or manual dispatch
           ▼
┌──────────────────────────────────────────────────────────────────┐
│                  GitHub Actions Pipeline                         │
│                                                                  │
│  ┌──────────┐  ┌───────────┐  ┌───────────┐  ┌──────────────┐  │
│  │ Discover  │→ │  Extract   │→ │   Drift   │→ │  Guard Rail  │  │
│  │ new pages │  │  KB data   │  │ Detection │  │  (max 15)    │  │
│  └──────────┘  └───────────┘  └─────┬─────┘  └──────┬───────┘  │
│                                     │                │          │
│                          ┌──────────┴──────────┐     │          │
│                          ▼                     ▼     │          │
│                   ┌─────────────┐     ┌─────────────┐│          │
│                   │  Generate   │     │    Sync     ││          │
│                   │ new widgets │     │   drifted   ││          │
│                   │ (Claude AI) │     │  (Claude AI)││          │
│                   └──────┬──────┘     └──────┬──────┘│          │
│                          │                   │       │          │
│                          └───────┬───────────┘       │          │
│                                  ▼                   │          │
│                   ┌──────────────────────────┐       │          │
│                   │  Update Widgetbook       │       │          │
│                   └──────────┬───────────────┘       │          │
│                              ▼                       │          │
│                   ┌──────────────────────────┐       │          │
│                   │  Validate                │       │          │
│                   │  • flutter analyze       │       │          │
│                   │  • compliance check      │       │          │
│                   │  • golden regression     │       │          │
│                   │  • update goldens        │       │          │
│                   └──────────┬───────────────┘       │          │
│                              ▼                       │          │
│                   ┌──────────────────────────┐       │          │
│                   │  Open Draft PR           │       │          │
│                   │  (human review required) │       │          │
│                   └──────────────────────────┘       │          │
└──────────────────────────────────────────────────────────────────┘
```

## Pipeline Steps

### Step 1 — Discover New Components

**Script:** `scripts/discover-components.mjs`

Fetches the Figma file structure (`GET /v1/files/:key?depth=1`) and scans for pages whose name starts with `❖` (the convention for design system components). Compares against `config/component-map.json` by `page_id` and slug. Any unknown page is added to the map with empty `dart_files: []`.

```bash
FIGMA_TOKEN=... node scripts/discover-components.mjs
# Output: NEW_COMPONENTS=bottom-navigation,pin-events  (machine-readable for CI)
```

### Step 2 — Extract Knowledge Base

**Script:** `scripts/extract-figma.mjs`

Fetches the full design token registries from Figma (colors, typography, effects) and saves them to `kb/registries/`. These are reference data used downstream by the compliance checker.

### Step 3 — Structural Drift Detection

**Script:** `scripts/detect-drift.mjs`

The core of cost optimization. Compares live Figma component data against locally cached specs in `kb/components/`. Uses **design-aware diffing** that ignores noise:

| Ignored (noise) | Flagged (design-relevant) |
|-----------------|--------------------------|
| Key ordering | Color changes |
| Float precision < 0.01 | Dimension changes |
| Position x/y values | Typography changes |
| Timestamps | Variant additions/removals |
| Figma node IDs | Layout structure changes |

Outputs a machine-readable report to `kb/sync-logs/drift-report.json`:

```json
{
  "stats": { "total": 42, "changed": 3, "unchanged": 37, "new": 2 },
  "changed": ["buttons", "checkboxes", "tabs"],
  "unchanged": ["avatar", "badges", "..."],
  "summary": "3 components changed, 37 unchanged, 2 new"
}
```

Only the **changed** components proceed to Step 6. This saves significant Claude API costs.

### Step 4 — Guard Rail

If more than **15 components** drifted in a single run, the pipeline aborts. This threshold catches major design system refactors that need manual review rather than automated sync.

### Step 5 — Generate New Widgets

**Script:** `scripts/generate-all-widgets.mjs`

For each newly discovered component (empty `dart_files`), the script:

1. Fetches the Figma component spec (node tree at depth 5)
2. Renders a screenshot via Figma Image API (scale=1, auto-downscale if >3.5MB)
3. Sends both to **Claude claude-sonnet-4-6** with a structured prompt
4. Claude returns a JSON response containing:
   - The Flutter widget (Dart code with enums for each variant axis)
   - A golden test file covering all variant combinations
5. Files are written to `lib/` and `test/goldens/components/`
6. `component-map.json` is updated with the new `dart_files` paths

**How variants are handled:** Claude sees the `componentPropertyDefinitions` from Figma (e.g., Type=Filled|Tonal|Outlined, State=Enabled|Disabled, Device=Desktop|Mobile) and generates Dart enums + switch logic. Golden tests group variants by axis (one image per axis, not per combination) to avoid combinatorial explosion.

```bash
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs --component badges
```

### Step 6 — Sync Drifted Components

**Script:** `scripts/sync-component.mjs`

For each component in the drift report's `changed` list:

1. Re-extracts the Figma spec + screenshot for **only** the changed components
2. Computes a structural diff between old and new specs
3. Sends the diff + current Dart code to Claude API
4. Claude returns targeted edits (JSON array of `{path, content, changes_made}`)
5. Edits are validated against a **path allowlist** (derived from `component-map.json`, with path canonicalization to prevent traversal attacks)
6. If `flutter analyze` fails, edits are rolled back from backup

```bash
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/sync-component.mjs --component avatar
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/sync-component.mjs --all
```

### Step 7 — Update Widgetbook

**Script:** `scripts/update-widgetbook.mjs`

Scans `component-map.json` for all components with `dart_files`, reads each widget to extract the main class name via regex, then:

1. Generates a `*_use_case.dart` file per component (with reasonable constructor defaults)
2. Rewrites `widgetbook/lib/widgetbook.dart` with all imports and `WidgetbookComponent` entries

```bash
node scripts/update-widgetbook.mjs
node scripts/update-widgetbook.mjs --dry-run
```

### Step 8 — Validation

Three validation layers run in sequence:

#### 8a. Flutter Analyze

```bash
flutter analyze lib/
```

Catches compile errors, type mismatches, and lint violations in generated code.

#### 8b. Deterministic Compliance Check

**Script:** `scripts/check-compliance-deterministic.mjs`

Parses the Dart code AST for design tokens and compares them against the Figma spec — no LLM involved:

| Dart pattern | Figma spec field | Tolerance |
|-------------|-----------------|-----------|
| `Color(0xFF...)` | `fills[].hex` | Exact hex match |
| `EdgeInsets.*` | `layout.padding` | +/- 1px |
| `BorderRadius.*` | `cornerRadius` | +/- 1px |
| `fontSize: N` | `textStyle.fontSize` | Exact |
| `fontWeight: FontWeight.wN` | `textStyle.fontWeight` | Exact |
| `SizedBox(width/height)` | `width/height` | +/- 1px |

Score per component = matched tokens / total tokens * 100. The average score and count of components below 30% appear in the PR body.

#### 8c. Golden Regression Check (2-phase)

**Script:** `scripts/check-golden-regressions.mjs`

1. **Phase 1 — Detect:** Runs `flutter test` WITHOUT `--update-goldens`. Parses output for pixel mismatches. Writes report to `kb/sync-logs/golden-regressions.json`.
2. **Phase 2 — Update:** Only after detection, runs `flutter test --update-goldens` to regenerate reference images.

This 2-phase approach ensures regressions are **reported in the PR** before being overwritten.

### Step 9 — Draft Pull Request

Uses `peter-evans/create-pull-request@v6` with a **fixed branch name** (`figma-sync/auto`) so subsequent runs update the same PR instead of creating duplicates.

The PR body includes:
- Drift detection summary (components checked vs. changed)
- New components discovered
- Compliance score (average + count below threshold)
- Golden regression count
- Cost optimization stats
- Human review checklist

PRs are always **draft** — human review is required before merge.

## Repository Structure

```
.
├── .github/workflows/
│   └── figma-sync.yml            # Nightly CI pipeline
├── config/
│   ├── component-map.json        # Source of truth: Figma page → Dart files mapping
│   └── figma-map.json            # Legacy mapping file
├── kb/
│   ├── components/               # Cached Figma specs (JSON) per component
│   │   ├── images/               # Rendered Figma screenshots (PNG)
│   │   └── _previous/            # Backup of pre-sync Dart files
│   ├── registries/               # Design tokens: colors.json, typography.json, effects.json
│   └── sync-logs/                # Drift reports, compliance reports, golden regressions
├── lib/                          # Flutter widget source code (40 components)
│   ├── avatar/
│   ├── badge/
│   ├── button/
│   └── ...
├── scripts/
│   ├── lib/
│   │   └── figma-api.mjs         # Shared: API client, spec extraction, tree walk, helpers
│   ├── discover-components.mjs   # Step 1: Auto-discover new Figma pages
│   ├── extract-figma.mjs         # Step 2: Extract design token registries
│   ├── detect-drift.mjs          # Step 3: Structural drift detection
│   ├── generate-all-widgets.mjs  # Step 5: Batch widget generation (Claude API)
│   ├── extract-figma-components.mjs # Extract specs + screenshots for specific components
│   ├── sync-component.mjs        # Step 6: Sync drifted components (Claude API)
│   ├── update-widgetbook.mjs     # Step 7: Auto-generate widgetbook entries
│   ├── check-compliance-deterministic.mjs  # Step 8b: Token compliance scoring
│   └── check-golden-regressions.mjs       # Step 8c: 2-phase golden check
├── test/goldens/components/      # Golden test files + reference PNGs
├── widgetbook/                   # Widgetbook app (visual component catalog)
└── pubspec.yaml                  # Flutter package definition
```

## Shared Module: `scripts/lib/figma-api.mjs`

All scripts import from a single shared module to avoid code duplication:

| Export | Used by | Purpose |
|--------|---------|---------|
| `createFigmaClient(token, fileKey)` | All 5 scripts | Returns `{ figmaGet, figmaGetImage }` with 429 retry + exponential backoff |
| `extractComponentSpec(node, depth)` | sync, drift, extract | Figma node tree → structured design spec |
| `findComponents(page)` | sync, drift, extract | Tree walk with `parentType` tracking (REST API has no parent back-pointer) |
| `rgbaToHex(c)` | sync, drift, extract | Figma RGBA (0-1 floats) → hex string |
| `slugify(name, separator)` | generate, discover | `"❖ Bottom Sheet"` → `"bottom_sheet"` or `"bottom-sheet"` |
| `sleep(ms)` | All | Rate limit pauses between API calls |

## Security

- **Path traversal protection:** LLM-generated file paths are canonicalized via `resolve()` and checked against an allowlist derived from `component-map.json`. Paths that escape the project root are rejected.
- **Allowlist enforcement:** The LLM can only write to directories where existing component files live.
- **Draft PRs only:** No auto-merge. Human review is required for every change.
- **Guard rail:** Pipeline aborts if >15 components drift simultaneously.
- **Rate limit resilience:** All Figma API calls use exponential backoff with `Retry-After` header respect, capped at 60s, up to 5 retries.

## Local Development

### Prerequisites

- Node.js 20+
- Flutter SDK (version from `pubspec.yaml`)
- `FIGMA_TOKEN` — Figma personal access token
- `ANTHROPIC_API_KEY` — Anthropic API key (for generation/sync steps)

### Common Commands

```bash
# Install Node dependencies
npm ci

# Discover new components (read-only, no API key needed)
FIGMA_TOKEN=... node scripts/discover-components.mjs --dry-run

# Detect drift without making changes
FIGMA_TOKEN=... node scripts/detect-drift.mjs

# Generate a single new widget
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/generate-all-widgets.mjs --component badges

# Sync a drifted component
FIGMA_TOKEN=... ANTHROPIC_API_KEY=... node scripts/sync-component.mjs --component avatar

# Update widgetbook entries
node scripts/update-widgetbook.mjs

# Run compliance check
node scripts/check-compliance-deterministic.mjs

# Run golden tests
flutter test test/goldens/components/

# Update golden references
flutter test test/goldens/components/ --update-goldens

# Launch widgetbook
cd widgetbook && flutter run -d chrome
```

### CI Trigger

The pipeline runs automatically at 2am UTC daily. To trigger manually:

```
GitHub → Actions → "Figma DS Sync" → Run workflow
  ├── dry_run: true        → detect drift only, no PR
  └── force_generate: true → re-generate all unimplemented components
```

## Cost Model

The pipeline is designed to minimize Claude API usage:

| Operation | API calls | When |
|-----------|-----------|------|
| Discover | 0 (Figma only) | Every run |
| Extract KB | 0 (Figma only) | Every run |
| Drift detection | 0 (Figma only, local diff) | Every run |
| Generate widget | 1 Claude call per new component | Only for new components |
| Sync drifted | 1 Claude call per changed component | Only for drifted components |

On a typical nightly run with 0-2 drifted components, the pipeline makes **0-2 Claude API calls** while checking all 42 components for drift using only the Figma REST API.

## How It Works (mental model)

The whole system rests on three stable anchors and one deterministic diff:

```
Figma file
  └─ Page "❖ Name"                      ← the ONLY thing treated as a component
       └─ COMPONENT_SET                   ← a group of variants
            ├─ COMPONENT "state=hover"    ← one variant = one state (identified by NAME)
            └─ COMPONENT "state=pressed"
                 └─ FRAME / TEXT / ...     ← internal nodes (recursed, depth ≤ 6)
```

1. **Discover** — list pages, keep only those starting with `❖`, key them by `page_id`.
2. **Extract** — walk each page, keep only `COMPONENT_SET` / `COMPONENT` nodes, serialize their design-relevant properties (size, color, radius, shadow, text, layout) into a cached JSON spec under `kb/components/`.
3. **Diff** — fetch live Figma, run `structuralDiff(cached, live)`. Arrays are matched **by `name`**, numbers compared with a `±0.01` float tolerance, IDs/positions/timestamps ignored. The result is a list of human-readable path strings (e.g. `…children[Reaction Bar].cornerRadius: 24 → 32`).
4. **Classify** — each diff string is tested against `DESIGN_PATTERNS` regexes. Matches are design changes; everything else is noise. A component drifts only if `designDiffs.length > 0`.
5. **Sync** — only drifted/new components are sent to Claude (`claude-sonnet-4-6`), which returns targeted Dart edits. Everything downstream (goldens, widgetbook) is **scoped to the changed slugs** so the PR stays small.

Detection is **100% deterministic** — no LLM. The LLM only translates an already-computed diff into code.

## Design Decisions & Trade-offs

### Why per-component structural diff instead of Figma's version API

Figma exposes `GET /files/:key/versions`, but its version ID is **global to the whole file**, not per component. One designer edit bumps the file version without telling you *which* component changed — and never *what* changed. We need both (to scope the Claude call and to build its prompt), so we cache a per-component spec and diff it ourselves. The file-level version would save nothing.

### Why match variants by `name`, not by node `id`

Node IDs are stable across renames but **change on copy/paste / recreate** — a designer duplicating a variant would trigger a phantom "removed + added". Names are stable across copy/paste but **change on rename**. We chose `name` (in `IGNORED_FIELDS` we explicitly drop `id`) because copy/paste is far more common than renaming in this team's workflow. Both have a blind spot; this one fires less often.

### Why a `❖` naming convention

There is no Figma-native flag for "this page is a shippable design-system component". The `❖` prefix is a cheap, explicit, human-controlled marker. Trade-off: it is a **convention, not a constraint** — forget the prefix and the component is invisible to the pipeline.

### Why regex classification of diffs

`classifyDiffs` runs `DESIGN_PATTERNS` (e.g. `/\.cornerRadius/`, `/\.fills/`, `/\.width(?!\.)/`) over the **stringified diff path**, not over the data structure. It is simple and readable, but **fragile** (see Limitations).

### Other deliberate choices

| Choice | Rationale | Trade-off |
|--------|-----------|-----------|
| Fixed PR branch `figma-sync/auto` | One rolling PR, no nightly duplicates | Force-updated; don't commit to it by hand |
| Guard rail at 15 drifted | Catches DS-wide refactors that need a human | Arbitrary threshold |
| Draft PRs only, no auto-merge | LLM output always reviewed | Requires a human in the loop |
| Two diff implementations (`detect-drift` + `sync-component`) | Each script self-contained | **Divergence risk** — float epsilon already drifted between them once |
| Scoped goldens/widgetbook regeneration | Small, reviewable PRs | Extra slug-plumbing in the workflow |

## Limitations (known fragilities)

| Area | Failure mode | Protected? |
|------|--------------|-----------|
| `❖` prefix | Forgotten → component never seen | ❌ human convention |
| Variant rename | Shows as `removed` + `added`, not a modification | ❌ matched by `name` |
| `DESIGN_PATTERNS` regex | A design field not in the list (e.g. `blendMode`, `itemSpacing`) is silently classified as noise → **missed drift** | ❌ allowlist by regex |
| Field rename in `extractComponentSpec` | Path string changes, regex no longer matches → silent | ❌ |
| `COMPONENT` nested inside a demo/example frame | Captured as a real component | ❌ |
| New component's `dart_files` | Auto-discovery fills `page_id` but **`dart_files: []`** — linking to existing code is manual | ⚠️ semi-auto |
| Page rename | Handled — matched by stable `page_id` | ✅ |

The regex classifier is the sharpest edge: it is a **denylist-by-omission**. A real change to a property nobody listed passes as noise and the component is reported clean.

## How This Could Be Improved

### In this codebase

- **Tag design-relevance at extraction, not after.** Instead of regex-matching stringified paths in `classifyDiffs`, mark each field as `design` vs `noise` inside `extractComponentSpec`. Removes the silent-omission failure mode and the path/field-name coupling.
- **Unify the two diff engines.** Collapse `detect-drift`'s `structuralDiff` and `sync-component`'s `diffVariantProperties` into one shared function in `figma-api.mjs` so the float tolerance and children-matching logic can't diverge again.
- **Match variants by `id` with `name` fallback.** Keep node `id` in the spec, match on it first, fall back to `name` — kills the rename → removed+added phantom while keeping copy/paste resilience.
- **Carry `componentPropertyDefinitions` through.** Figma exposes the real variant axes (`Type=Filled|Tonal`); parsing them would let drift describe state changes semantically instead of as opaque name strings.

### On the Figma side

- **Replace the `❖` convention with a Figma "Published Component" / library status** queried via the API, so membership isn't a typo away from breaking.
- **Adopt strict variant property naming** (no free-text variant names) so the `name`-as-identity assumption holds.

### Architecturally

- **Webhook-driven instead of nightly cron.** Figma supports file-update webhooks — react to actual edits rather than polling 42 components every night.
- **Persist a per-node fingerprint** (hash of design-relevant fields) in the spec, so drift is a cheap hash compare and the human-readable diff is computed only for the components that actually changed.
