### Status: NOT_IMPLEMENTED

### Component: Cards

### Variants Coverage
- **Stacked card** — 3 variants defined in Figma — ❌ Not implemented
- **Style=Outlined** — 1 variant defined in Figma — ❌ Not implemented
- **Style=Elevated** — 1 variant defined in Figma — ❌ Not implemented
- **Style=Filled** — 1 variant defined in Figma — ❌ Not implemented
- **Horizontal card** — 3 variants defined in Figma — ❌ Not implemented
- **17 additional components** — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Stacked card layout | Defined (truncated) | None | ❌ |
| Outlined style | Border variant defined | None | ❌ |
| Elevated style | Shadow/elevation variant | None | ❌ |
| Filled style | Filled background variant | None | ❌ |
| Horizontal card layout | Horizontal orientation, 3 variants | None | ❌ |
| Corner radius | Defined per variant | None | ❌ |
| Spacing/padding | Defined per variant | None | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation coverage
- All 3 card structural styles (Outlined, Elevated, Filled) are absent
- Both layout orientations (Stacked, Horizontal) are absent
- At least 22 total component variants across the page are unimplemented
- Corner radii, padding, fill colors, and typography from Figma have no Flutter counterpart

### Recommendations
- Create a `LinagoraCard` widget supporting a `style` enum: `outlined`, `elevated`, `filled`
- Implement a `layout` parameter to switch between `stacked` (vertical) and `horizontal` orientations
- Extract corner radius, padding, and color tokens from the Figma spec once full (non-truncated) JSON is available
- Cover all 3 variants per layout orientation (likely: default, with media, with actions — common card patterns)
- Audit the 17 additional unnamed components once Figma spec is fully expanded