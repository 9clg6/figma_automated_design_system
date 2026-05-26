### Status: NOT_IMPLEMENTED

### Component: ❖ Headers

### Variants Coverage
- **Bar logo web** — Not implemented (web logo bar variant)
- **Header** (4 variants) — Not implemented (covers multiple layout/state combinations)
- **State=Default, Type=Search** — Not implemented
- **State=Contact, Type=Search** — Not implemented
- **State=invitation, Type=Search** — Not implemented
- **38+ additional variants** — Not implemented (states/types unknown due to truncation)

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Bar logo web width | 937px canvas frame | — | ✗ |
| Header canvas frame | 2097×2341px | — | ✗ |
| Header component frame | 694×1194px | — | ✗ |
| Title box frame | 887×1095px | — | ✗ |
| Layout mode | Defined (truncated) | — | ✗ |
| Padding | Defined (truncated) | — | ✗ |
| Corner radii | Defined (truncated) | — | ✗ |
| Fills / colors | Defined (truncated) | — | ✗ |
| Typography | Defined via styleRefs | — | ✗ |

### Issues Found
- No Dart files exist for this component — zero implementation coverage
- At least **43 component variants** across 6+ named components are unimplemented
- Four distinct structural sections are defined in Figma: `Header bar logo`, `Header`, `Header component`, and `Title box` — none are reflected in Flutter
- Full variant property details (colors, spacing, typography, radii) are truncated in the spec, meaning a deeper Figma API inspection is required before implementation can begin

### Recommendations
- Fetch full (non-truncated) Figma data for all 43+ variants to extract exact hex colors, font sizes/weights, padding, and corner radii before implementation
- Implement a base `AppHeader` Flutter widget with named constructors or a `type` enum covering at minimum: `Default`, `Search`, `Contact`, `Invitation`, and `BarLogoWeb`
- Map `Header component` (694px wide) as the mobile/compact layout and `Bar logo web` (937px) as the web/desktop layout
- Use `Title box` spec to define a reusable title sub-widget with correct padding and corner radii once values are untruncated
- Register all color and typography tokens from `styleRefs` into the design system theme before building header variants