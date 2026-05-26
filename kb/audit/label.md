### Status: NOT_IMPLEMENTED

### Component: ❖ Label

### Variants Coverage
| Figma Variant | Flutter Implementation |
|---|---|
| Theme=Light, Variant=Default | ❌ Not implemented |
| Theme=Dark, Variant=Default | ❌ Not implemented |
| Theme=Light, Variant=Collapsed | ❌ Not implemented |
| Theme=Dark, Variant=Collapsed | ❌ Not implemented |
| Labels (8 sub-variants) | ❌ Not implemented |
| 20+ additional variants | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Light theme support | ✅ Defined | ❌ Missing | ✗ |
| Dark theme support | ✅ Defined | ❌ Missing | ✗ |
| Default variant | ✅ Defined | ❌ Missing | ✗ |
| Collapsed variant | ✅ Defined | ❌ Missing | ✗ |
| Layout (auto-layout frame) | ✅ Defined (1139×1163 canvas) | ❌ Missing | ✗ |
| Corner radii | ✅ Defined | ❌ Missing | ✗ |
| Padding/spacing | ✅ Defined | ❌ Missing | ✗ |

### Issues Found
- No Dart files exist for this component — zero implementation present
- At least **25+ variants** across themes (Light/Dark) and states (Default, Collapsed, + 20 more) are entirely unimplemented
- The `Labels` component group contains **8 sub-variants** with no Flutter counterpart
- Canvas frame is `1139×1163` with defined corner radii and auto-layout padding — structural layout is unspecified in Flutter
- Exact colors, typography, spacing, and radius values cannot be extracted due to truncated Figma spec — full spec access is required before implementation

### Recommendations
- Request **untruncated Figma spec** to extract exact values: hex colors, font sizes/weights, border radii, padding, and gap values for all variants
- Implement a `LinagoraLabel` widget with:
  - A `theme` parameter (`light` / `dark`)
  - A `variant` parameter (`default` / `collapsed` + additional states)
  - Token-based color and typography properties aligned to the Linagora Design System
- Cover all 25+ variants with widget tests and visual regression snapshots
- Ensure the `Collapsed` variant handles text truncation or icon-only display as defined in Figma