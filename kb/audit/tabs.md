### Status: NOT_IMPLEMENTED

### Component: Tabs

### Variants Coverage
- **Search Tabs** — Not implemented (includes Active?=False and Active?=True sub-states)
- **Active?=False** — Not implemented
- **Active?=True** — Not implemented
- **Tabs (main component)** — Not implemented (10+ variants detected, truncated in spec)
- **Type=Scrollable, Style=Secondary, Configuration=Label & Icon** — Not implemented
- **25+ additional variants** — Not implemented

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Active state (tab indicator) | Defined (True/False) | — | ❌ |
| Tab type | Scrollable | — | ❌ |
| Tab style | Secondary (+ likely Primary) | — | ❌ |
| Tab configuration | Label & Icon (+ likely Label only, Icon only) | — | ❌ |
| Search Tabs variant | Defined | — | ❌ |
| Layout mode | Horizontal (inferred) | — | ❌ |
| Settings frame | 712×916 | — | ❌ |
| Basics frame | 1828×932 | — | ❌ |

### Issues Found
- No Dart files exist for this component — zero implementation
- Both sub-pages ("Tabs Settings" and "Tabs basics") are fully unimplemented
- Active/Inactive tab state logic is entirely absent
- At least 3 configuration modes inferred (Label only, Icon only, Label & Icon) — none covered
- At least 2 style variants inferred (Primary, Secondary) — none covered
- At least 2 type variants inferred (Fixed, Scrollable) — none covered
- Search Tabs variant (with its own active state) is fully absent

### Recommendations
- Create a `LinagoraTabs` widget supporting `type` (Fixed / Scrollable), `style` (Primary / Secondary), and `configuration` (Label, Icon, Label & Icon)
- Implement an `isActive` boolean per tab item to drive indicator and label/icon color changes
- Implement `SearchTabs` as a separate variant widget with Active?=True / Active?=False states
- Extract exact hex colors, spacing, typography, and indicator dimensions from full (non-truncated) Figma spec before implementation
- Map `TabBar` / `TabBarView` from Flutter Material to Figma variants where possible, overriding theme properties to match design tokens