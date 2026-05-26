### Status: NOT_IMPLEMENTED

### Component: Tooltips

### Variants Coverage
- **Container** — Not implemented (2 variants: default and with shadow/effects)
- **Type=Plain** — Not implemented (single-line text tooltip)
- **Type=Rich** — Not implemented (rich content tooltip, includes shadow effects)

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Container shape | Rounded corners (cornerRadius defined) | None | ❌ |
| Plain tooltip fill | Defined fill color | None | ❌ |
| Rich tooltip fill | Defined fill color | None | ❌ |
| Rich tooltip shadow | Drop shadow effect present | None | ❌ |
| Layout padding | Defined padding on container | None | ❌ |
| Typography | Defined text style via styleRefs | None | ❌ |
| Elevation/effects | Present on Rich + Container v2 | None | ❌ |

> ⚠️ Note: Figma variant details are truncated — exact hex colors, px radii, font weights, and shadow values could not be extracted. A full audit requires untruncated Figma data.

### Issues Found
- No Dart file exists for this component whatsoever
- Three distinct component types (Container, Type=Plain, Type=Rich) are fully absent
- Shadow/elevation properties defined in Rich and Container variants have no Flutter equivalent
- No token/style references mapped from Figma `styleRefs`

### Recommendations
- Create a `LinagoraTooltip` widget covering at minimum two variants: `plain` and `rich`
- Implement `Plain` as a simple `Container` with rounded corners, background fill, and a single `Text` child
- Implement `Rich` as a `Container` with a `BoxShadow` matching the Figma effect and support for multi-element content (title + body)
- Map corner radius, padding, fill colors, and typography from the Linagora design token system once untruncated Figma data is available
- Use Flutter's `Tooltip` widget as a base or build a custom overlay depending on dismiss/positioning requirements