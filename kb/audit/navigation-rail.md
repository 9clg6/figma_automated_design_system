### Status: NOT_IMPLEMENTED

### Component: Navigation Rail

### Variants Coverage
- **Bottom navigation** (8 variants) — ❌ Not implemented
- **State=Default, Digit Chat?=false** — ❌ Not implemented
- **State=Default, Digit Chat?=true** — ❌ Not implemented
- **State=Hovered, Digit Chat?=false** — ❌ Not implemented
- **State=Hovered, Digit Chat?=true** — ❌ Not implemented
- **Additional ~49 variants** (likely covering Active, Pressed, Focused, Disabled states × Digit Chat true/false combinations) — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component file(s) | Defined | None | ❌ |
| Bottom navigation bar | Present (8 variants) | None | ❌ |
| Navigation Rail (side) | Present | None | ❌ |
| Interactive states | Default, Hovered, + ~others | None | ❌ |
| Badge/digit on chat icon | true / false toggle | None | ❌ |
| Theme colors frame | Defined | None | ❌ |

### Issues Found
- No Dart implementation file exists for this component
- Both **Bottom Navigation** (mobile) and **Navigation Rail** (tablet/desktop) sub-components are missing
- State variants (Default, Hovered, Pressed, Active, Focused, Disabled) are fully unimplemented
- The "Digit Chat?" boolean variant (badge/counter on chat icon) has no Flutter counterpart
- Theme color tokens defined in the Figma "Theme colors" frame are not mapped anywhere in Flutter code
- The full variant matrix (~54+ combinations) has no coverage

### Recommendations
- Implement a `LinagoraBottomNavigationBar` widget covering all 8 bottom-nav variants with active/inactive/hover/pressed states
- Implement a `LinagoraNavigationRail` widget for wider screen layouts using Flutter's `NavigationRail` as a base
- Add a `showBadge` (bool) property to toggle the chat digit badge, matching the "Digit Chat?=true/false" Figma property
- Map Figma theme color tokens to the Flutter color system before building the widgets
- Handle all interactive states using `MaterialState` / `WidgetState` resolvers to cover Default, Hovered, Pressed, Focused, Active, and Disabled
- Consider a unified adaptive navigation component that switches between bottom bar and rail based on screen width breakpoints