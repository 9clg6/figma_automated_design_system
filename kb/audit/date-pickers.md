### Status: NOT_IMPLEMENTED

### Component: Date Pickers

### Variants Coverage
- **Modal Date Picker** — ❌ Not implemented
- **Input Date Picker** — ❌ Not implemented
- **Docked Input Date Picker [desktop]** — ❌ Not implemented
- **Building Blocks / Local M3 Calendar Cell** — ❌ Not implemented
- **Building Blocks / Year** — ❌ Not implemented
- **7 additional sub-components** — ❌ Not implemented (details truncated in spec)

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Modal Date Picker | Defined | None | ❌ |
| Input Date Picker | Defined | None | ❌ |
| Docked Input (desktop) | Defined | None | ❌ |
| Calendar Cell building block | Defined | None | ❌ |
| Year building block | Defined | None | ❌ |
| Canvas size | 2572×2724px | N/A | ❌ |
| Corner radii | Defined (values truncated) | None | ❌ |
| Layout/padding | Defined (values truncated) | None | ❌ |

### Issues Found
- No Dart files exist for this component — implementation is entirely absent
- All three picker surfaces (Modal, Input, Docked/Desktop) are unimplemented
- Building block sub-components (Calendar Cell, Year picker, and 7 others) have no Flutter counterpart
- No theming, color tokens, typography, or spacing values have been extracted or applied
- Desktop-specific variant (Docked Input) is particularly notable as it likely requires responsive layout handling

### Recommendations
- Implement `ModalDatePicker` widget aligned to the M3 spec defined in Figma, reusing Flutter's `showDatePicker` as a base and customising `DatePickerThemeData`
- Implement `InputDatePicker` wrapping Flutter's `InputDatePickerFormField` with Linagora design tokens (colors, radii, typography)
- Implement `DockedInputDatePicker` as a desktop-specific widget with appropriate layout constraints
- Extract and apply correct corner radii, padding, and color values once the Figma spec truncation is resolved (request full token export)
- Build calendar cell and year-picker building blocks as reusable internal widgets to compose all three picker surfaces consistently