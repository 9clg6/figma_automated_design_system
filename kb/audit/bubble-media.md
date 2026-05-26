### Status: NOT_IMPLEMENTED

### Component: Bubble Media

### Variants Coverage
| Figma Variant | Flutter Implementation |
|---|---|
| File | ❌ Not implemented |
| Type=Preview | ❌ Not implemented |
| Type=Media | ❌ Not implemented |
| File Download | ❌ Not implemented |
| Downloaded?=False | ❌ Not implemented |
| + 8 additional sub-variants | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Canvas size | 1408×1251px frame | — | ❌ |
| Corner radius | Defined per variant | — | ❌ |
| Layout mode | Vertical/directional (per component) | — | ❌ |
| Fills/colors | Defined per variant | — | ❌ |
| Typography | Defined in children | — | ❌ |
| Download state | Boolean (Downloaded?=True/False) | — | ❌ |
| Media preview | Dedicated Type=Preview variant | — | ❌ |

### Issues Found
- No Dart file exists for this component — zero implementation coverage
- All 13+ Figma component variants are unaccounted for in Flutter
- Download state logic (`Downloaded?=False` + implied `True`) has no widget counterpart
- File, Preview, and Media sub-types require distinct rendering logic, none present
- Truncated Figma spec limits full property extraction (exact hex colors, spacing, radii values unavailable)

### Recommendations
- Create a `BubbleMediaWidget` with a `type` enum covering: `file`, `preview`, `media`, `fileDownload`
- Implement a `downloaded` boolean flag to toggle download state rendering
- Extract exact corner radii, padding, and fill colors from Figma by un-truncating the component spec before implementation
- Use a `Stack` or `Column` layout to support media preview overlay and file metadata display
- Ensure download progress indicator is included for the `fileDownload` variant