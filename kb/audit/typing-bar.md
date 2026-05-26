### Status: NOT_IMPLEMENTED

### Component: Typing Bar

### Variants Coverage
- **Type=Default, DM?=False, Chat=True** — ❌ Not implemented
- **Type=Default, DM?=True, Chat=False** — ❌ Not implemented
- **Type=Typing, DM?=False, Chat=True** — ❌ Not implemented
- **Type=Typing, DM?=True, Chat=False** — ❌ Not implemented
- **Base Typing Bar** (8 sub-variants) — ❌ Not implemented
- **29+ additional variants** (truncated in spec) — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component exists | Yes | No | ❌ |
| Mobile layout frame | 1447×1560px | — | ❌ |
| Web layout frame | 1640×1170px | — | ❌ |
| Input typing bar (web) | 846×1443px | — | ❌ |
| Alternate typing bar | 1344×1261px | — | ❌ |
| Strokes/borders | Defined per variant | — | ❌ |
| Style refs (colors/typography) | Defined per variant | — | ❌ |
| Fills | Defined per variant | — | ❌ |
| Corner radii | Defined | — | ❌ |
| Layout mode | Vertical/horizontal (truncated) | — | ❌ |

### Issues Found
- No Dart file exists for this component anywhere in the codebase
- All 5+ named variants (Type × DM? × Chat combinations) are entirely absent
- Both mobile and web layout frames are unimplemented
- Stroke, fill, typography, and spacing tokens are defined in Figma but have no Flutter counterpart
- The component has at least 34 total component entries (5 visible + "29 more") — none covered

### Recommendations
- Create a `TypingBarWidget` covering at minimum the four named variants: `Default/Chat`, `Default/DM`, `Typing/Chat`, `Typing/DM`
- Implement a `type` enum (`default`, `typing`) and boolean flags `isDM`, `isChat`
- Extract fill colors, stroke weights, corner radii, and typography from full (untruncated) Figma tokens before implementation
- Build separate layout paths for **mobile** and **web** (responsive or platform-specific widget)
- Reference the "Input typing bar web" sub-frame for web-specific input field sizing