### Status: PARTIAL

### Component: ❖ Lists

### Variants Coverage
- **List (0 Density)** — Partially implemented via `TwakeListItem` (basic container only)
- **List: -2 Density** — ❌ Not implemented (no density variant support)
- **List: -4 Density** — ❌ Not implemented (no density variant support)
- **List Item: 0 Density** (238+ sub-variants: 1-line, 2-line, 3-line, Leading/Trailing combinations) — ❌ Not implemented
- **Leading elements** (Icon, Avatar, Checkbox, Switch, Radio, Image) — ❌ Not implemented
- **Trailing elements** (Icon, Checkbox, Switch, Radio, Text) — ❌ Not implemented
- **Overline / Supporting text** — ❌ Not implemented
- **Selected / Focused / Hovered / Pressed / Disabled states** — ⚠️ Hover/Selected partially via `TwakeInkWell`; others missing

---

### Property Comparison
| Property | Figma | Flutter | Match |
|---|---|---|---|
| Density variants | 0, -2, -4 | None supported | ❌ |
| List item height (0 density) | 56px (1-line), 72px (2-line), 88px (3-line) | Arbitrary `height?` param | ❌ |
| Leading slot | Icon/Avatar/Checkbox/Switch/Radio/Image | Not present | ❌ |
| Trailing slot | Icon/Checkbox/Switch/Radio/Text | Not present | ❌ |
| Overline text | Supported | Not present | ❌ |
| Supporting/Subtitle text | Supported | Not present | ❌ |
| Divider/border | `LinagoraDividerStyle.material()` | Applied via `BoxDecoration` | ⚠️ Unverifiable |
| Selected state color | Material `secondaryContainer` tone | `LinagoraHoverStyle.material().selectedColor` | ⚠️ Unverifiable |
| Hover state | Defined in Figma | `splashColor` via InkWell | ⚠️ Partial |
| Disabled state | Defined in Figma | Not implemented | ❌ |
| Pressed / Focus states | Defined in Figma | Not implemented | ❌ |
| Border radius (item) | Typically 0dp (list) | `LinagoraHoverStyle.material().borderRadius` | ⚠️ Unverifiable |
| Padding (horizontal) | 16px left/right | Not enforced, passed externally | ❌ |
| Padding (vertical, 0-density) | 8px top/bottom | Not enforced | ❌ |

---

### Issues Found
- **No density system**: Figma defines 3 density levels (0, -2, -4) affecting item height; Flutter has no such parameter
- **No structured list item widget**: `TwakeListItem` is a generic container — it has no headline, supporting text, overline, leading, or trailing slots
- **Missing content slots**: All rich content variants (238+ in Figma) are unsupported — no leading/trailing widget slots defined in the API
- **Hardcoded externally-driven layout**: `padding`, `height`, and `margin` are fully delegated to callers with no design-system defaults enforced
- **No interaction states beyond hover/selected**: Pressed, focused, and disabled visual states absent
- **`TwakeInkWell` missing `mouseCursor`**: Figma implies pointer cursor on hover for interactive items

---

### Recommendations
1. Create a `TwakeListItemData` model encapsulating: `headline`, `supportingText`, `overline`, `leading`, `trailing`, `density`
2. Implement density enum `ListDensity { d0, dMinus2, dMinus4 }` mapping to heights `56/52/48px` (1-line baseline)
3. Enforce default horizontal padding of **16px** and vertical padding of **8px** from design tokens
4. Add `leading` and `trailing` widget slots with constrained sizing (icon: 24px, avatar: 40px)
5. Implement `disabled` opacity state (typically 38% opacity on content per Material 3)
6. Validate `LinagoraDividerStyle` and `LinagoraHoverStyle` hex values against Figma color tokens