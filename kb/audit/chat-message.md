### Status: NOT_IMPLEMENTED

### Component: ❖ Chat message

### Variants Coverage
- **Message list** (54373:28410) — 252+ variants — ❌ Not implemented
- **Default state** (Chat=False, State=Default, Mute=False, Hovered=False, Read=False, Media=False, Selected=False) — ❌ Not implemented
- **Typing state** (State=Typing) — ❌ Not implemented
- **Reaction state** (State=Reaction) — ❌ Not implemented
- **Media photo state** (State=Media photo) — ❌ Not implemented
- **259+ additional component variants** — ❌ Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Message list variants | 252+ entries | — | ❌ |
| Chat toggle (Chat=True/False) | Defined | — | ❌ |
| Mute toggle | Defined | — | ❌ |
| Hovered state | Defined | — | ❌ |
| Read state | Defined | — | ❌ |
| Selected state | Defined (label width: 94px, height: 28px) | — | ❌ |
| Selected overlay (×3 instances) | TEXT nodes on canvas | — | ❌ |
| Chat message frame | 4620×5108px, padded layout | — | ❌ |
| Sliding message frame | 711×686px | — | ❌ |
| Chat+Media toggle | Defined | — | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation
- All 7 boolean/enum variant axes (Chat, State, Mute, Hovered, Read, Chat+Media, Selected) are unimplemented
- The **State** axis covers at minimum: Default, Typing, Reaction, Media photo — all missing
- The **Sliding message** sub-component (711×686px) has no counterpart
- Selected state label text nodes (94×28px, ×3 canvas instances) are not represented

### Recommendations
- Create a `ChatMessageTile` widget covering all 7 variant axes as named parameters/enums
- Implement state variants in priority order: `Default` → `Typing` → `Reaction` → `Media photo`
- Build a `SlidingMessage` wrapper widget (swipe-to-reply gesture layer, ~711×686 reference)
- Extract a `MessageList` scrollable container that maps the 252+ list variants
- Once Figma truncation is lifted, re-audit to capture exact hex colors, font sizes, corner radii, and spacing values for each variant