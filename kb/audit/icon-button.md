### Status: NOT_IMPLEMENTED

### Component: ❖ Icon Button

### Variants Coverage
| Figma Variant | Flutter |
|---|---|
| Theme=Light, Configuration=Standard, State=Enable | ❌ Missing |
| Theme=Light, Configuration=Filled, State=Enable | ❌ Missing |
| Theme=Light, Configuration=Outlined, State=Enable | ❌ Missing |
| Theme=Light, Configuration=Tonal, State=Enable | ❌ Missing |
| Theme=Dark, Configuration=Standard/Filled/Outlined/Tonal | ❌ Missing |
| States: Enable, Hover, Focus, Pressed, Disabled | ❌ Missing |
| Web variant set (40+ variants total) | ❌ Missing |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component size | 48×48px | — | ❌ |
| Configurations | Standard, Filled, Outlined, Tonal | — | ❌ |
| Themes | Light, Dark | — | ❌ |
| States | Enable, Hover, Focus, Pressed, Disabled | — | ❌ |
| Disabled opacity | 0.38 | — | ❌ |
| Layout | Auto-layout, centered icon | — | ❌ |
| Icon child | Configurable via `Icon` property | — | ❌ |

### Issues Found
- No Dart file exists for this component
- All 4 configurations (Standard, Filled, Outlined, Tonal) are unimplemented
- Both Light and Dark themes are unimplemented
- All interactive states (Hover, Focus, Pressed, Disabled) are unimplemented
- Disabled opacity of `0.38` defined in Figma is not reflected anywhere
- The component covers 40+ variants across the web set — none are present in Flutter

### Recommendations
- Create `linagora_icon_button.dart` implementing all 4 configurations as an enum: `standard`, `filled`, `outlined`, `tonal`
- Support `theme` (light/dark) and `state` (enabled, hover, focus, pressed, disabled) parameters
- Set button size to **48×48px** with centered icon layout
- Apply **opacity 0.38** for the disabled state
- Use a configurable `icon` widget property matching Figma's `Icon#52081:6` slot
- Align with Material 3 `IconButton` variants as a base, then override tokens to match Linagora design tokens