### Status: NOT_IMPLEMENTED

### Component: Bottom Sheets

### Variants Coverage
- **Bottom sheet (light, Modal=True)** — ❌ Not implemented
- **Bottom sheet (light, Modal=False)** — ❌ Not implemented
- **Bottom sheet-dark (Modal=True)** — ❌ Not implemented
- **Bottom sheet-dark (Modal=False)** — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Light theme variant | Defined (`Bottom sheet`) | None | ❌ |
| Dark theme variant | Defined (`Bottom sheet-dark`) | None | ❌ |
| Modal=True variant | Defined (both themes) | None | ❌ |
| Modal=False variant | Defined (both themes) | None | ❌ |
| Corner radii | Defined (top corners rounded) | None | ❌ |
| Layout padding | Defined | None | ❌ |
| Fill / background color | Defined (light + dark) | None | ❌ |
| Frame dimensions | 1104px wide, 2053px tall (canvas) | None | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation coverage
- All 4 variant combinations (2 themes × 2 modal states) are entirely missing
- Light and dark theme background fills are unimplemented
- Top corner radii (drag-handle sheet style) are unimplemented
- Modal overlay behavior (Modal=True scrim/barrier) is not handled
- Non-modal (persistent) bottom sheet mode (Modal=False) is not handled
- Internal layout, padding, and child content structure are absent

### Recommendations
- Create a `LinagoraBottomSheet` widget supporting a `modal` boolean parameter
- Implement a `ThemeMode`-aware background color using design token fills for light (`Bottom sheet`) and dark (`Bottom sheet-dark`) variants
- Apply top-left and top-right corner radii as defined in Figma corner radii spec (likely `16px` or `28px` — confirm from full token data)
- For `Modal=True`: use `showModalBottomSheet` with a scrim/barrier color matching design spec
- For `Modal=False`: use `showBottomSheet` (persistent) or a `BottomSheet` widget directly
- Extract padding and spacing values from the Figma layout spec once full token data is available
- Ensure drag handle indicator is included if present in truncated children nodes