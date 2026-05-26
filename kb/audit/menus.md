### Status: NOT_IMPLEMENTED

### Component: ❖ Menus

### Variants Coverage
| Figma Variant | Flutter Implementation |
|---|---|
| Menu with Text field - Example 1 (light) | ❌ Not implemented |
| Menu with Text field - Example 2 (light) | ❌ Not implemented |
| Menu - Icon button Example | ❌ Not implemented |
| Menu with Text field - Example 1 (dark) | ❌ Not implemented |
| Menu with Text field - Example 2 (dark) | ❌ Not implemented |
| Menu action frame | ❌ Not implemented |
| 13+ additional variants (truncated) | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Light theme support | Defined | None | ❌ |
| Dark theme support | Defined | None | ❌ |
| Text field variant | Defined | None | ❌ |
| Icon button variant | Defined | None | ❌ |
| Menu action subgroup | Defined (1307×1336) | None | ❌ |
| Menu frame | Defined (1620×1695) | None | ❌ |
| Layout mode | Defined (vertical/auto) | None | ❌ |
| Corner radii | Defined | None | ❌ |
| Padding | Defined | None | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation coverage
- At least 18 total component variants are defined in Figma with no Flutter counterpart
- Two distinct structural groups exist (`Menu` and `Menu action`) — neither is modelled
- Both light and dark theme variants are specified but unimplemented
- Three distinct interaction patterns are present: text field menu, icon button menu, and action menu — all missing

### Recommendations
- Create a `LinagoraMenu` widget covering at minimum:
  - **Text field trigger** variant (Examples 1 & 2, light + dark)
  - **Icon button trigger** variant (light + dark)
  - **Menu action** variant with its full child structure
- Implement **dark/light theming** from the outset using `ThemeData` or a custom token system
- Extract corner radii, padding, and spacing values from the full (non-truncated) Figma spec before coding
- Request untruncated Figma JSON for the 13 additional variants to ensure full coverage before implementation begins