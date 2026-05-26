### Status: NOT_IMPLEMENTED

### Component: Message Counter

### Variants Coverage
| Figma Variant | Flutter Implementation |
|---|---|
| `@?=True, Single Digit?=False, Multiple Digits?=False` (@ / mention badge) | ❌ Not implemented |
| `@?=False, Single Digit?=True, Multiple Digits?=False` (single digit count) | ❌ Not implemented |
| `@?=False, Single Digit?=False, Multiple Digits?=True` (multiple digits count) | ❌ Not implemented |
| Base `Message Counter` (3 internal sub-variants) | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Corner radius | Defined (likely circular/pill) | N/A | ❌ |
| Fill / background color | Defined per variant | N/A | ❌ |
| Text style | Defined (label typography) | N/A | ❌ |
| Layout padding | Defined (auto-layout) | N/A | ❌ |
| Width/Height | Variant-specific fixed sizes | N/A | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation
- All 4 Figma variants (`@` mention, single digit, multi-digit, base) are unaddressed
- Component appears to be a notification/unread badge with at least 3 display states: mention indicator (`@`), numeric single-digit, and numeric multi-digit (likely pill-shaped for overflow)

### Recommendations
- Create a `MessageCounterWidget` supporting three display modes:
  1. **Mention mode** (`@` symbol, fixed circular size)
  2. **Single digit** (circular badge, e.g. `20×20` dp)
  3. **Multiple digits** (pill/rounded-rectangle shape with horizontal padding)
- Extract background color, text color, corner radius, and font size from the full (non-truncated) Figma JSON before implementing
- Use `BoxDecoration` with `borderRadius` and `color` to match fill + radius tokens
- Align typography with the design system's label style tokens once spec is fully accessible