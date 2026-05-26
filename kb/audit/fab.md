### Status: NOT_IMPLEMENTED

### Component: Floating Action Buttons (FAB)

### Variants Coverage
- **Small FAB** — Not implemented (16+ variants defined in Figma)
- **Regular FAB** — Not implemented
- **Large FAB** — Not implemented (implied by naming conventions)
- **Extended FAB** — Not implemented (implied by component set)
- **Configuration variants**: `primary`, `secondary`, `tertiary` — None implemented
- **State variants**: `enabled`, `hovered`, `focused`, `pressed` — None implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Small FAB size | ~40×40px (inferred) | — | ✗ |
| Regular FAB size | ~56×56px (M3 standard) | — | ✗ |
| Large FAB size | ~96×96px (M3 standard) | — | ✗ |
| Corner radius | Rounded (12–28px range) | — | ✗ |
| Color configs | primary / secondary / tertiary | — | ✗ |
| States | enabled / hovered / focused / pressed | — | ✗ |
| Elevation/shadow | Defined via `effects` | — | ✗ |
| Icon child | Present in all variants | — | ✗ |
| Layout padding | Defined per variant | — | ✗ |

### Issues Found
- No Dart file exists for this component — zero implementation
- All 3 color configurations (primary, secondary, tertiary) are absent
- All 4 interactive states (enabled, hovered, focused, pressed) are absent
- All size tiers (small, regular, large — and likely extended) are absent
- Shadow/elevation effects defined in Figma are not captured anywhere
- Extended FAB label text variant is likely defined but not implemented

### Recommendations
- Create a `LinagoraFab` widget with a `size` enum: `small`, `regular`, `large`, `extended`
- Add a `configuration` enum: `primary`, `secondary`, `tertiary` to drive container/icon colors
- Implement `MaterialStatesController` or `WidgetStateProperty` for hover, focus, pressed overlays
- Map corner radii per size tier (e.g., small → 12px, regular → 16px, large → 28px per M3)
- Apply elevation shadows matching Figma `effects` definitions (level 3 default, level 4 on hover)
- Extract exact hex values and spacing from full (non-truncated) Figma variant data before implementation