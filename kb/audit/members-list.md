### Status: NOT_IMPLEMENTED

### Component: Members list

### Variants Coverage
- **Member list 1** — 29+ variants (list container, not implemented)
- **Role=Owner, Type=Default, Last seen=False, Mattrix?=False** — not implemented
- **Role=Owner, Type=Unselect, Last seen=False, Mattrix?=False** — not implemented
- **Role=Owner, Type=Selected, Last seen=False, Mattrix?=False** — not implemented
- **Role=Owner, Type=Default, Last seen=False, Mattrix?=True** — not implemented
- **38+ additional role/type/visibility combinations** — not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component file(s) | Defined | None | ❌ |
| Member list container | 1663×2572px frame | None | ❌ |
| Color theme frame | 1840×1118px frame | None | ❌ |
| Role variants | Owner + (implied: Member, Admin, etc.) | None | ❌ |
| Type variants | Default, Unselect, Selected | None | ❌ |
| Last seen toggle | True / False | None | ❌ |
| Matrix (Mattrix?) flag | True / False | None | ❌ |

### Issues Found
- No Dart implementation file exists for this component
- All 43+ Figma variants across role, type, last-seen, and Matrix dimensions are unimplemented
- Both the list container frame and the color theme frame are absent
- Selection state handling (Default / Unselect / Selected) has no Flutter equivalent
- "Last seen" visibility flag has no Flutter equivalent
- Matrix/non-Matrix display mode has no Flutter equivalent

### Recommendations
- Create a `MemberListItem` widget covering the three **Type** states: `Default`, `Unselect`, `Selected`
- Add a `role` parameter (e.g. `MemberRole.owner`, `.admin`, `.member`) to drive label/icon differences
- Add `showLastSeen` boolean to toggle the last-seen sub-label
- Add `isMatrix` boolean to toggle Matrix-specific display
- Implement a `MembersList` wrapper widget matching the container layout (vertical list, padding derived from the 1663-wide Figma frame)
- Extract color tokens from the **"Members list colors theme"** frame and register them in the design-system token file before building the widget