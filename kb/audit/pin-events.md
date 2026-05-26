### Status: NOT_IMPLEMENTED

### Component: Pin Events

### Variants Coverage
- **Theme=Light, Type=File, no Caption?=False, Mobile?=False** — ❌ Not implemented
- **Theme=Dark, Type=File, no Caption?=False, Mobile?=False** — ❌ Not implemented
- **Theme=Light, Type=File, no Caption?=True, Mobile?=False** — ❌ Not implemented
- **Theme=Dark, Type=File, no Caption?=True, Mobile?=False** — ❌ Not implemented
- **47+ additional variants** (Light/Dark × multiple Types × Caption × Mobile combinations) — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Theme axis | Light / Dark | N/A | ❌ |
| Type axis | File (+ others inferred) | N/A | ❌ |
| Caption toggle | True / False | N/A | ❌ |
| Mobile layout | True / False | N/A | ❌ |
| Canvas frame size | 2429×1983 | N/A | ❌ |
| Pin Bar frame size | 1566×796 | N/A | ❌ |
| Layout mode | Vertical (FRAME) | N/A | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation present
- At least 47 named variants across 4 axes (Theme, Type, Caption, Mobile) are fully unimplemented
- Two distinct top-level layout frames identified in Figma: a general content frame (`2429×1983`) and a dedicated **Pin Bar** frame (`1566×796`), neither has a Flutter counterpart
- Dark theme support is entirely absent
- Mobile-responsive layout variant is entirely absent
- Caption visibility toggle has no Flutter equivalent

### Recommendations
- Create a `PinEventCard` widget supporting all four variant axes:
  - **Theme**: implement via `ThemeData`/color tokens for Light and Dark modes
  - **Type**: parameterize with an enum (e.g. `PinEventType.file`, + remaining types from full spec)
  - **Caption**: expose a `bool showCaption` parameter to toggle caption visibility
  - **Mobile**: use a `bool isMobile` or `BoxConstraints`-based layout to switch between desktop (`1566px` wide Pin Bar) and mobile layouts
- Retrieve the full (untruncated) Figma spec to capture exact color hex values, typography styles, spacing, and corner radii before implementation
- Implement a dedicated `PinBar` widget matching the `1566×796` frame layout
- Ensure all tokens (colors, spacing, radii) align with the Linagora Design System token library