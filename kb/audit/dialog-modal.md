### Status: PARTIAL

### Component: ❖ Dialog modal

### Variants Coverage
- **Basic Dialog (Icon=false)** — ✅ Partially implemented via `ConfirmationDialogBuilder`
- **Basic Dialog (Icon=true)** — ❌ Not implemented (`useIconAsBasicLogo` flag exists but no icon rendering logic found in `_buildTitle` or above title area)
- **List Dialog** — ✅ Partially implemented via `OptionsDialog`
- **Bottom Sheet variant** — ✅ Partially implemented (both builders support `isBottomSheet`/`showAsBottomSheet`)
- **Modal designed variants** — ❌ Cannot confirm coverage (spec truncated, 24+ components listed)

---

### Property Comparison

| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Dialog corner radius | 28px (Material 3 standard) | 16px | ❌ |
| Bottom sheet corner radius | 20px (top only) | 20px top-only | ✅ |
| Dialog background color | Surface/neutral[100] | `Colors.white` (hardcoded) | ⚠️ |
| Container width | ~280–560px adaptive | 421px fixed, maxWidth param | ⚠️ |
| Content padding (start/end) | 24px | 32px | ❌ |
| Content padding (top) | 24px | 24px | ✅ |
| Content padding (bottom) | 24px | 32px | ❌ |
| Action buttons top spacing | 24px | 44px | ❌ |
| Button height | 40px | 48px | ❌ |
| Button corner radius | 100px (pill) | 100px | ✅ |
| Title style | `headlineSmall` 24sp/32 | `headlineSmall` | ✅ |
| Title color | neutral[10] ~`#1C1B1F` | `#424244` | ❌ |
| List item divider | 1px separator | 1px `BorderSide` top | ✅ |
| List item padding | 16px vertical | 8px all | ❌ |
| Options dialog max width | 280px | 448px | ❌ |
| Close icon | SVG asset | `Icons.close` (Material icon) | ⚠️ |

---

### Issues Found
- **Corner radius**: Dialog uses `16px` instead of expected `28px` (Material 3 M3 dialog spec, consistent with Figma)
- **Icon=true variant**: `useIconAsBasicLogo` accepted but no icon is rendered — the build method has no corresponding `_buildIcon()` call
- **Hardcoded white**: `Colors.white` used directly instead of `LinagoraRefColors.material().neutral[100]` or theme surface color — breaks dark mode/theming
- **Title color mismatch**: `#424244` used vs. `LinagoraRefColors.material().neutral[10]` (~`#1C1B1F`) used inconsistently between the two files
- **Action button top padding**: `44px` vs Figma expected `~24px`
- **Button height**: `48px` vs Figma `40px`
- **Content padding**: `32px` start/end vs Figma `24px`; bottom `32px` vs `24px`
- **OptionsDialog max width**: `448px` vs likely Figma `280px` for list dialog
- **List item padding**: `8px` all sides vs expected `16px` vertical padding per item
- **Close button icon**: Uses `Icons.close` (Material) in `OptionsDialog` but SVG asset in `ConfirmationDialogBuilder` — inconsistent

---

### Recommendations
- Fix dialog `cornerRadius` to `28px` across both builders
- Implement icon rendering for `Icon=true` variant in `_BodyContent`
- Replace all `Colors.white` with `LinagoraRefColors.material().neutral[100]` or `theme.colorScheme.surface`
- Align title color to `LinagoraRefColors.material().neutral[10]` consistently in both files
- Reduce action button top padding from `44px` → `24px`, button height from `48px` → `40px`
- Adjust content padding: start/end `32px` → `24px`, bottom `32px` → `24px`
- Constrain `OptionsDialog` max width to `280px` to match list dialog Figma spec
- Standardize close button icon to use the same SVG asset across both dialogs