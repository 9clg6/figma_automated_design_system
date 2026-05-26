### Status: PARTIAL

### Component: ❖ On action hovered bar

### Variants Coverage
| Figma Variant | Flutter Implemented |
|---|---|
| On Thread?=False, Reply?=False, Add Reaction?=False, Moreover?=False, Hover on Thread?=True (Chat) | ❌ Not individually handled |
| On Thread?=False, Reply?=True, Hover on Thread?=True (Chat) | ❌ Not individually handled |
| On Thread?=False, Reply?=True, Hover on Thread?=True (DM) | ❌ Not individually handled |
| On Thread?=False, Add Reaction?=True, Hover on Thread?=True (Chat) | ❌ Not individually handled |
| Action Bar Hovered (14+ variants) | ❌ No per-variant logic |
| Type?=Chat vs Type?=DM distinction | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Hover color | Truncated/unknown | `LinagoraSysColors.material().surface` | ⚠️ Unverifiable |
| Selected color | Truncated/unknown | `LinagoraSysColors.material().secondaryContainer` | ⚠️ Unverifiable |
| Border radius | Truncated/unknown | `4px` (all corners) | ⚠️ Unverifiable |
| Duplicate borderRadius fields | N/A | Both `borderRadius` & `hoverBorderRadius` set to `4px` | ⚠️ Redundant |
| Variant-specific colors | Multiple fills per variant | Single static color pair | ❌ Missing |
| Thread/DM/Chat type distinction | Separate components | Not differentiated | ❌ Missing |

### Issues Found
- **Variant logic absent**: The spec defines 14+ named variants across Chat/DM types and boolean flags (Reply, AddReaction, Moreover, OnThread, isThread). Flutter uses a single static style with no conditional logic.
- **Redundant border radius**: `borderRadius` (`BorderRadiusGeometry`) and `hoverBorderRadius` (`BorderRadius`) are both defined at `4px` — duplicated fields with no differentiation.
- **Fills/colors unverifiable**: Figma fill values are `[truncated]`, so exact hex color match cannot be confirmed.
- **No Type?=DM support**: DM-specific variants have no separate styling path.
- **Factory pattern doesn't scale**: Single `_material()` factory cannot express per-variant styles.

### Recommendations
- Expose a variant-aware constructor or factory (e.g., `LinagoraHoverStyle.forVariant({required MessageType type, bool isReply, bool isThread, ...})`).
- Add separate color tokens for Chat vs DM hover states once Figma fills are untruncated.
- Remove redundant `hoverBorderRadius` field or consolidate into a single `BorderRadius` property.
- Request untruncated Figma fill data to verify all hex color values against `LinagoraSysColors` tokens.