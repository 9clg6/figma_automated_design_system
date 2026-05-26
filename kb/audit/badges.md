### Status: NOT_IMPLEMENTED

### Component: Badges

### Variants Coverage
- **Size=Small** (light & dark) — ❌ Not implemented
- **Size=Large-Single Digit** (light & dark) — ❌ Not implemented
- **Size=Multiple Digits** (light & dark) — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Small badge | Defined (dot/no-text style) | None | ❌ |
| Large single-digit badge | Defined (circular with number) | None | ❌ |
| Multiple-digits badge | Defined (pill/rounded rect with number) | None | ❌ |
| Corner radius | Defined per variant | None | ❌ |
| Fill color (light theme) | Defined | None | ❌ |
| Fill color (dark theme) | Defined | None | ❌ |
| Typography (label) | Defined | None | ❌ |
| Layout/padding | Defined (auto-layout on multi-digit) | None | ❌ |

### Issues Found
- No Dart file exists for the Badges component whatsoever
- All 3 size variants are absent: Small (dot), Large-Single Digit (circle), Multiple Digits (pill)
- Both light (`Badge`) and dark (`Badge-dark`) theme variants are unimplemented
- No badge color tokens, corner radius, or text style are mapped in Flutter
- The multiple-digits variant uses auto-layout (horizontal padding) — this responsive behavior is not captured anywhere

### Recommendations
- Create a `LinagoraBadge` widget supporting a `count` parameter to drive variant selection:
  - `count == null` or hidden → **Small** dot variant (no text, circular dot)
  - `1–9` → **Large-Single Digit** (fixed-size circle, centered number)
  - `≥ 10` → **Multiple Digits** (pill shape with horizontal padding, auto-width)
- Implement light/dark theme support using `Badge` and `Badge-dark` fill color tokens from Figma
- Define corner radii, fill colors, and text styles from the Figma style references once full spec values are extracted
- Register the component in the design system token layer to ensure theme-aware color switching