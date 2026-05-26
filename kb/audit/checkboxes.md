### Status: NOT_IMPLEMENTED

### Component: Checkboxes

### Variants Coverage
- **Type=Default, State=Enabled** — ❌ Not implemented
- **Type=Default, State=Pressed** — ❌ Not implemented
- **Type=Default, State=Focused** — ❌ Not implemented
- **Type=Default, State=Hovered** — ❌ Not implemented
- **Type=Default, State=Disabled** — ❌ Not implemented
- **Type=Error+Unselected, State=Pressed** — ❌ Not implemented
- **Type=Error+Unselected, State=Focused** — ❌ Not implemented
- **Type=Error+Unselected, State=Hovered** — ❌ Not implemented
- **Type=Error+Unselected, State=Disabled** — ❌ Not implemented
- **Additional variants (57+ total)** — ❌ Not implemented

> The Figma spec defines at minimum **62 component variants** spanning two primary axes: **Type** (Default, Error+Unselected, and likely Selected/Indeterminate states) × **State** (Enabled, Pressed, Focused, Hovered, Disabled).

---

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Corner radius | Defined (truncated) | — | ❌ |
| Fill / background color | Defined per variant | — | ❌ |
| Opacity (Disabled state) | Reduced opacity applied | — | ❌ |
| Layout mode | Auto-layout (horizontal/vertical) | — | ❌ |
| Padding | Defined | — | ❌ |
| Width / Height | Defined per variant | — | ❌ |
| Error state styling | Distinct fill/border color | — | ❌ |
| Interactive states | Pressed, Focused, Hovered | — | ❌ |

---

### Issues Found
- No Dart file exists for this component — zero implementation coverage
- All 62+ Figma variants are unaddressed
- Error state (distinct color treatment) has no Flutter equivalent
- Disabled opacity behaviour (applied at component level in Figma) is not replicated
- Interactive states (Pressed, Focused, Hovered) require `MaterialState` / `WidgetState` handling — none present
- Corner radius and padding tokens are defined in Figma but have no mapped Flutter theme values

---

### Recommendations
- Create a `LinagoraCheckbox` widget wrapping or replacing Flutter's `Checkbox`
- Map Figma **Type** axis → `isError: bool`, `isIndeterminate: bool` parameters
- Map Figma **State** axis → `MaterialStateProperty` for fill, border, and overlay colors
- Apply corner radius token to `RoundedRectangleBorder` on the checkbox shape
- Use `Opacity` widget or `MaterialStateProperty<Color>` alpha for the Disabled state
- Define a `CheckboxThemeData` extension in the design system token file to centralise all colour/spacing values extracted from Figma