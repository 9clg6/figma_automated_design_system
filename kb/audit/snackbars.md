### Status: NOT_IMPLEMENTED

### Component: Snackbars

### Variants Coverage
Based on the Figma spec, the following variants are defined — none are implemented in Flutter:

- **Lines**: Single line / Two lines
- **Action**: True / False
- **Close affordance**: True / False
- **Longer action**: True / False

This yields approximately **22+ distinct variant combinations** (confirmed by 17+ listed components in the spec).

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Corner radius | Defined (truncated) | None | ❌ |
| Background fill | Defined (truncated) | None | ❌ |
| Layout/padding | Defined (truncated) | None | ❌ |
| Shadow/effects | Defined (truncated) | None | ❌ |
| Typography | Defined via styleRefs | None | ❌ |
| Action button | Present in variants | None | ❌ |
| Close icon affordance | Present in variants | None | ❌ |
| Single-line layout | Present in variants | None | ❌ |
| Two-line layout | Present in variants | None | ❌ |

### Issues Found
- No Dart file exists for this component
- All 22+ Figma variants are unimplemented
- No snackbar widget, theme, or helper utility found in the codebase
- Action button (short and long label), close icon, and multi-line text support are all missing

### Recommendations
- Create a `LinagoraSnackbar` widget supporting the following props:
  - `message` (String, required) — single or two-line support
  - `actionLabel` (String?, optional) — short and longer action variants
  - `onActionPressed` (VoidCallback?)
  - `showCloseAffordance` (bool, default: false)
- Apply design tokens from Figma once full spec is available (corner radius, background color, padding, shadow, typography)
- Register a `SnackBarThemeData` entry in the app's global `ThemeData` to centralise styling
- Request un-truncated Figma JSON to extract exact hex colors, pixel spacing, border radii, and font styles before implementation