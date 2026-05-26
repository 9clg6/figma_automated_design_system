### Status: NOT_IMPLEMENTED

### Component: ❖ Buttons

### Variants Coverage

Based on the Figma spec, the `Button` component exposes a rich combinatorial variant matrix. No Flutter implementation exists to cover any of them.

| Variant Axis | Figma Values | Flutter |
|---|---|---|
| Type | `filled`, (implied: `outlined`, `text`) | ❌ None |
| Icon configuration | `none`, (implied: `leading`, `trailing`) | ❌ None |
| State | `enabled`, (implied: `hovered`, `focused`, `disabled`) | ❌ None |
| Device | `on-desktop`, `on-mobile` | ❌ None |
| Theme | `light`, `dark` | ❌ None |

> The full matrix yields **300 variants** (5+ confirmed components listed, spec notes "295 more" and "299 more").

---

### Property Comparison

| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Button type (filled/outlined/text) | Defined | Not implemented | ❌ |
| Corner radius | Defined per variant | Not implemented | ❌ |
| Fill color (light/dark) | Defined per theme | Not implemented | ❌ |
| Typography / label style | Defined via styleRefs | Not implemented | ❌ |
| Layout / padding | Defined per device breakpoint | Not implemented | ❌ |
| Icon support (leading/trailing/none) | Defined | Not implemented | ❌ |
| State effects (hover, focus, disabled) | Defined | Not implemented | ❌ |
| Effects (shadows) | Present on some variants | Not implemented | ❌ |

---

### Issues Found

- No Dart files exist for this component — zero implementation coverage
- All 300 Figma variants are unimplemented
- Both `light` and `dark` theme token bindings are missing
- Desktop vs. mobile sizing/padding differentiation is not handled
- State management (enabled, hovered, focused, disabled) is absent
- Icon configuration variants (`none`, leading icon, trailing icon) are not covered
- Shadow/effects defined on certain variants are not represented

---

### Recommendations

1. **Create a `LinagoraButton` widget** accepting: `type` (filled/outlined/text), `iconConfig` (none/leading/trailing), `state`, and theme-awareness
2. **Extract design tokens** for fill colors, border colors, text styles, and corner radii from Figma styleRefs for both light and dark themes
3. **Implement device-responsive padding** using a breakpoint utility (`on-desktop` vs `on-mobile` layout values)
4. **Handle all interactive states** via Flutter's `WidgetState` / `MaterialState` resolvers (enabled, hovered, focused, disabled)
5. **Add elevation/shadow** for variants that define `effects` in Figma
6. Aim for a single composable widget that covers the full 300-variant matrix through parameters rather than 300 separate widgets