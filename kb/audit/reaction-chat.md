### Status: PARTIAL

### Component: ❖ Reaction Chat

### Variants Coverage
- Figma spec is **empty** (no variants, no visual tokens defined in JSON)
- Flutter implements a functional reaction picker + dialog with custom styling

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Variants | None specified | ReactionsPicker + ReactionsDialogWidget | N/A |
| Background color | Not specified | `LinagoraSysColors.material().onPrimary` | N/A |
| Border radius | Not specified | 32px default | N/A |
| Container height | Not specified | 56px default | N/A |
| Emoji size | Not specified | 28px (text), 40px (container) | N/A |
| Emoji margin | Not specified | vertical: 4, horizontal: 3 | N/A |
| More icon size | Not specified | 32px | N/A |
| More icon color | Not specified | `LinagoraRefColors.material().neutral[80]` | N/A |
| Shadow 1 | Not specified | `#00000026`, offset(0,4), blur 8, spread 3 | N/A |
| Shadow 2 | Not specified | `#0000004D`, offset(0,1), blur 3, spread 0 | N/A |
| Backdrop blur | Not specified | sigmaX/Y: 9 | N/A |
| Dialog padding | Not specified | left/right: 20px | N/A |
| Reaction bottom padding | Not specified | bottom: 8px | N/A |

### Issues Found
- **Figma spec is empty**: No visual tokens, variants, colors, or layout data are defined in the Figma component — full comparison is impossible
- Cannot verify correctness of any hardcoded values (border radius `32`, height `56`, emoji size `28`/`40`, shadow values) against design intent
- `Icons.expand_circle_down` used for "more emojis" — cannot confirm icon matches Figma asset
- Selected emoji highlight uses `onSurface.withOpacity(0.1)` — unverifiable without spec

### Recommendations
- **Update Figma spec**: The component node appears unpublished or empty (`"status": "empty"`); request the designer to publish full variant/token definitions
- Once spec is available, audit hardcoded values: `borderRadius=32`, `height=56`, `emojiSize=28`, shadow colors against design tokens
- Replace any magic numbers with named design tokens from `LinagoraSysColors` / `LinagoraRefColors` for maintainability
- Confirm the "more emoji" icon matches the Figma asset exactly