### Status: NOT_IMPLEMENTED

### Component: ❖ Message type icon

### Variants Coverage
- `Type=Attach, Theme=Light` — ❌ Not implemented
- `Type=Attach, Theme=Dark` — ❌ Not implemented
- `Type=Video, Theme=Light` — ❌ Not implemented
- `Type=Video, Theme=Dark` — ❌ Not implemented
- `lin_message-type-icon_24px` (14 total sub-variants) — ❌ Not implemented
- Additional 10+ type/theme combinations (inferred from `... 10 more`) — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Size | 24×24 px (primary component) | N/A | ❌ |
| Theme support | Light / Dark | N/A | ❌ |
| Message types | Attach, Video, + ≥10 more | N/A | ❌ |
| Corner radius | Defined (values truncated) | N/A | ❌ |
| Fill colors | Defined per theme variant | N/A | ❌ |
| Layout | Auto-layout with padding | N/A | ❌ |
| Icon content | Per-type SVG/vector children | N/A | ❌ |

### Issues Found
- No Dart file exists for this component — zero implementation coverage
- All 14+ variants across message types (Attach, Video, and at least 10 others) and themes (Light/Dark) are absent
- The 24px sizing, theming system, fill colors, and layout padding are entirely undefined in Flutter
- No theme-switching logic (Light ↔ Dark) is present

### Recommendations
- Create a `MessageTypeIcon` widget accepting a `MessageType` enum and a `theme` (light/dark) parameter
- Implement all type variants: at minimum `attach`, `video`, plus the remaining 10+ types from Figma
- Apply 24×24 px fixed size constraint matching `lin_message-type-icon_24px`
- Use `ThemeData` or a custom token system to switch fill colors between Light and Dark themes
- Extract corner radius and padding values from full Figma spec before implementation
- Consider an icon-map approach (`Map<MessageType, Widget>`) for scalable variant management