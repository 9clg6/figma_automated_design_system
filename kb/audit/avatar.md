### Status: PARTIAL

### Component: ❖ Avatar

### Variants Coverage
| Figma Variant | Flutter Implemented |
|---|---|
| Style=avatar (image-based) | ✅ Via `imageProvider` |
| Style=Avatar Photo | ✅ Via `imageProvider` |
| Style=monogram (initials) | ✅ Via `text` fallback |
| Style=check | ❌ Not implemented |
| Avatar label chips md (40) | ❌ Not implemented |
| Additional ~161 variants | ❌ Unknown/Not implemented |

---

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Default size | 40px (chips md) | 56px (`defaultSize`) | ❌ |
| Avatar shape | Circle (`cornerRadius` present) | Circle (`BoxShape.circle`) | ✅ |
| Text color | Unspecified (white inferred) | `Colors.white` | ⚠️ Assumed |
| Font size | Not extractable (truncated) | 22px, w700 | ⚠️ Unverified |
| Font weight | Not extractable | `FontWeight.w700` | ⚠️ Unverified |
| Letter spacing | Not extractable | -0.013 | ⚠️ Unverified |
| Gradient direction | Not extractable | `topLeft → bottomRight` | ⚠️ Unverified |
| Gradient colors | Not extractable | 10 predefined palettes | ⚠️ Unverified |
| Gradient stops | Not extractable | `[0.1484, 0.9603]` | ⚠️ Unverified |
| Check/badge overlay | Defined in Figma | ❌ Absent | ❌ |
| Label chips layout | Defined in Figma (md=40px) | ❌ Absent | ❌ |
| Box shadow | Present in some variants | Optional only | ⚠️ Partial |

---

### Issues Found
- **Size mismatch**: Figma specifies 40px for "chips md" variant; Flutter defaults to `56.0px` with no 40px preset
- **Missing Style=check variant**: No checkmark/selection overlay state implemented anywhere
- **Missing label chips component**: Figma defines a chip-style avatar with label at 40px — no equivalent widget exists
- **`maxChar` truncation bug**: `text.runes.length > defaultMaxChar` correctly checks rune count, but then calls `text.substring(0, 2)` on byte index — may corrupt multi-byte characters (e.g. emojis)
- **Gradient color selection**: `text.avatarColors` hashing logic is not auditable here — consistency with Figma color mapping is unverified
- **No size variants/presets**: Figma likely defines xs/sm/md/lg sizes; Flutter has a single flat `size` parameter with no named presets
- **`CircleAvatar` wrapping `Container`**: Double-layered circle widget may cause clipping or shadow rendering inconsistencies

---

### Recommendations
- Add `defaultSize = 40.0` constant or a named size enum matching Figma size scale (e.g. `sm=32`, `md=40`, `lg=56`)
- Implement a `check` overlay variant using a `Stack` with a checkmark icon badge
- Create an `AvatarChip` widget combining the avatar + label at 40px height to match the chips md spec
- Fix the multi-byte text truncation: use `text.runes.take(maxChar)` instead of `text.substring`
- Expose box shadow presets matching Figma elevation tokens rather than raw optional `List<BoxShadow>`
- Audit `string_extension.dart` `avatarColors` method against Figma's defined gradient palette mapping