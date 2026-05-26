### Status: PARTIAL

### Component: ❖ Dividers

### Variants Coverage
| Figma Variant | Flutter Implemented |
|---|---|
| horizontal/full-width | ⚠️ Partial (only generic style, no orientation) |
| horizontal/inset | ❌ Missing |
| horizontal/middle-inset | ❌ Missing |
| horizontal/with-subhead | ❌ Missing |
| vertical/full-width | ❌ Missing |
| vertical/inset | ❌ Missing |
| vertical/middle-inset | ❌ Missing |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Thickness | 1px (standard) | `1.0` | ✅ |
| Orientation support | Horizontal + Vertical | Horizontal only (`Border.bottom`) | ❌ |
| Inset spacing | Defined per variant | Not implemented | ❌ |
| Middle-inset spacing | Defined per variant | Not implemented | ❌ |
| Subhead text style | Defined in `with-subhead` variant | Not implemented | ❌ |
| Color source | Figma design token (outline/outline-variant likely) | `surfaceTint` via `opacityLayer3` — unverified against spec | ⚠️ |
| Named style variants | 7+ variants | Single static factory `material()` | ❌ |

### Issues Found
- **Only one generic style exists** (`LinagoraDividerStyle.material()`); all 7 Figma variants are absent
- **No vertical divider support** — `borderDecoration` is hardcoded to `Border.bottom`; no `Border.right` or axis-aware logic
- **No inset/middle-inset padding** — Figma inset variants require left (and/or right) padding/indent; not modeled at all
- **No `with-subhead` variant** — requires a `Text` widget embedded alongside the divider line; entirely missing
- **Color token unverified** — `surfaceTint.opacityLayer3` is used, but Figma likely maps divider color to `outline` or `outlineVariant` token; cannot confirm match without full token data (truncated spec)
- **No configurability** — all fields are `final` with a single private constructor; no way to instantiate custom inset or color variants

### Recommendations
- Add named constructors or a factory per variant: `horizontal()`, `horizontalInset()`, `horizontalMiddleInset()`, `horizontalWithSubhead()`, `vertical()`, `verticalInset()`, `verticalMiddleInset()`
- Introduce an `indent`/`endIndent` property (matching Figma inset pixel values once spec is untruncated) and an `axis` property
- Implement `withSubhead` variant as a dedicated widget (not just a style class) containing a `Row` with `Expanded` divider lines and a `Text` label
- Verify divider color token against Figma — cross-check whether `outlineVariant` (`LinagoraSysColors.material().outlineVariant`) is the correct token instead of `surfaceTint.opacityLayer3`