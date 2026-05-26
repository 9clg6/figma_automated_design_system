### Status: NOT_IMPLEMENTED

### Component: Chips (❖ Chips)

### Variants Coverage
- **Input Chip** — 48+ variants defined in Figma · ❌ Not implemented
- **Selected style + label avatar & trailing icon (dragged)** — ❌ Not implemented
- **Selected style + label & avatar (dragged)** — ❌ Not implemented
- **Selected style + leading icon label trailing icon (dragged)** — ❌ Not implemented
- **Selected style + leading icon & label (dragged)** — ❌ Not implemented
- **537+ additional component variants** — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component type | Chip (Input, Filter, Suggestion, etc.) | — | ❌ |
| States | Default, Focused, Pressed, Dragged, Disabled | — | ❌ |
| Styles | Selected, Unselected | — | ❌ |
| Configurations | Label only, Leading icon + label, Label + trailing icon, Avatar + label, Label + avatar + trailing icon | — | ❌ |
| Corner radius | Rounded (pill-style, likely 8px or full radius) | — | ❌ |
| Layout | Horizontal, auto-layout with padding | — | ❌ |
| Fill colors | Style-dependent (selected/unselected surface tokens) | — | ❌ |
| Effects | Elevation/shadow on dragged state | — | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation
- All 537+ Figma variants (styles × configurations × states) are unaccounted for
- Input Chip is the primary chip type defined with the most variant depth (48+ sub-variants)
- Dragged state includes visual elevation effects not yet captured anywhere
- Selected vs. unselected fill tokens are defined in Figma but have no Flutter equivalent

### Recommendations
- Create a `LinagoraChip` widget supporting: `style` (selected/unselected), `configuration` (label-only, leading icon, trailing icon, avatar), and `state` (default, focused, pressed, dragged, disabled)
- Use Flutter's `InputChip`, `FilterChip`, or a custom widget as base, themed via `ChipThemeData`
- Map Figma fill tokens to the design system color palette for selected/unselected surfaces and label colors
- Implement elevation/shadow for the `dragged` state using `BoxShadow` or `Material` elevation
- Extract corner radius and padding values from full Figma variant data once truncation is resolved