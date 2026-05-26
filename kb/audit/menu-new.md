### Status: NOT_IMPLEMENTED

### Component: ❖ menu new (desktop+mobile)

### Variants Coverage
- **Component 1** (COMPONENT_SET, 10 variants) — Not implemented
- **emoji bar=true, items=5** — Not implemented
- **emoji bar=false, items=5** — Not implemented
- **emoji bar=true, items=6** — Not implemented
- **emoji bar=false, items=6** — Not implemented
- **Menu item** (COMPONENT_SET, 2 variants) — Not implemented
- 9 additional component variants (truncated) — Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Container width | 216px | — | ✗ |
| Container height | 233px (6 items) | — | ✗ |
| Corner radius (menu panel) | 20px | — | ✗ |
| Corner radius (component set) | 5px | — | ✗ |
| Layout mode | Vertical (auto-layout) | — | ✗ |
| Emoji bar toggle | true / false | — | ✗ |
| Item count variants | 5 items, 6 items (+ more) | — | ✗ |
| Fill | Styled (ref present) | — | ✗ |
| Effects | Drop shadow × 2 | — | ✗ |
| Stroke weight | 1px | — | ✗ |
| Menu item variants | 2 variants (normal/hover?) | — | ✗ |

### Issues Found
- No Dart files exist for this component whatsoever
- The menu panel instance (`Component 2`) defines two drop-shadow effects — no Flutter elevation/shadow equivalent coded
- The `emoji bar` boolean property (true/false) driving a reaction bar sub-component is entirely absent
- Item count configurability (5 vs 6+ items) has no Flutter counterpart
- Corner radius of **20px** on the floating panel and **5px** on component-set borders are unimplemented
- `Menu item` sub-component (256px wide, 2 variants — likely default + hover/active states) has no implementation

### Recommendations
- Create a `ContextMenuWidget` Flutter widget with:
  - Configurable `itemCount` parameter (min 5, supporting 6+)
  - Boolean `showEmojiBar` parameter toggling the emoji reaction row
  - `borderRadius: BorderRadius.circular(20)` on the panel container
  - Two `BoxShadow` entries to replicate the Figma double drop-shadow effect
  - A `MenuItem` sub-widget covering both normal and active/hover states (2 variants)
- Extract fill color and shadow values from Figma style references before implementation
- Ensure the menu supports both desktop (mouse hover states) and mobile (tap states) as implied by the component name