### Status: NOT_IMPLEMENTED

### Component: Switch

### Variants Coverage
Based on the Figma spec, the following variant dimensions are defined (20+ total combinations):

| Dimension | Values |
|-----------|--------|
| Selected | `true`, `false` |
| State | `enabled`, `hovered`, `focused`, `pressed`, `disabled` |
| Icon | `true`, `false` |

- ❌ No Flutter implementation exists for any variant

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component | Switch toggle control | — | ❌ |
| Selected states | true / false | — | ❌ |
| Interactive states | enabled, hovered, focused, pressed, disabled | — | ❌ |
| Icon variant | with icon / without icon | — | ❌ |
| Sizing spec | Defined (dedicated "Switch sizing" frame) | — | ❌ |

### Issues Found
- No Dart file exists for the Switch component
- All 20+ Figma variants (Selected × State × Icon) are unimplemented
- The Figma spec includes a dedicated **"Switch sizing"** frame, suggesting specific size tokens (track width/height, thumb size) that need to be captured
- Icon support (thumb icon on/off) is a distinct visual variant not covered anywhere

### Recommendations
- Create a `LinagoraSwitch` widget implementing:
  - **Track**: sized per Figma sizing frame, with distinct fill colors for selected/unselected states
  - **Thumb**: correct radius and size per spec, with icon-on-thumb variant
  - **States**: overlay/ripple colors for `hovered`, `focused`, `pressed`; reduced opacity for `disabled`
  - **Icon toggle**: expose an `icon` parameter to render icon inside the thumb
- Extract sizing and color tokens from the Figma "Switch sizing" frame once full node data is available
- Map to `SwitchThemeData` in the design system theme for consistent styling across the app