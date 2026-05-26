### Status: NOT_IMPLEMENTED

### Component: Side Sheets

### Variants Coverage
- **Side Sheet** (light) — defined in Figma, no Flutter implementation
- **Side Sheet-dark** — defined in Figma, no Flutter implementation

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Light variant | Defined (`53198:27851`) | — | ❌ |
| Dark variant | Defined (`53198:27903`) | — | ❌ |
| Frame width | 3276px (canvas) | — | ❌ |
| Frame height | 2036px (canvas) | — | ❌ |
| Corner radii | Defined (truncated, likely rounded on leading edge) | — | ❌ |
| Layout mode | Defined (likely horizontal/flex) | — | ❌ |
| Padding | Defined (truncated) | — | ❌ |
| Fill/background color | Defined via style ref (light + dark tokens) | — | ❌ |

### Issues Found
- No Dart files exist for this component whatsoever
- Both light and dark theme variants are unimplemented
- Corner radii, padding, fill colors, and layout properties cannot be verified due to missing implementation
- Figma spec includes style references for fill colors (likely surface/container tokens) that have no Flutter counterpart

### Recommendations
- Create a `SideSheet` Flutter widget supporting both light and dark themes
- Implement corner radius on the leading edge only (standard Material side sheet pattern — typically `28px` top-left and bottom-left radii)
- Apply correct surface fill color using Material 3 `colorScheme.surface` or `colorScheme.surfaceContainerLow` tokens for light/dark parity
- Support standard internal layout: header, content area, and optional action row with appropriate padding (typically `24px` horizontal, `16–24px` vertical)
- Register the component under the Linagora Design System widget catalog once implemented