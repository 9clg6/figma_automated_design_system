### Status: NOT_IMPLEMENTED

### Component: Timestamp

### Variants Coverage
| Figma Variant | Flutter |
|---|---|
| Today=True, Months=False, Year=False, On-scrolling=False | ❌ Not implemented |
| Today=True, Months=False, Year=False, On-scrolling=True | ❌ Not implemented |
| Today=False, Months=True, Year=False, On-scrolling=False | ❌ Not implemented |
| Today=False, Months=True, Year=False, On-scrolling=True | ❌ Not implemented |
| Today=False, Months=False, Year=True, On-scrolling=False | ❌ Not implemented |
| Today=False, Months=False, Year=True, On-scrolling=True | ❌ Not implemented |
| 7+ additional variants (truncated) | ❌ Not implemented |

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component existence | Defined | None | ❌ |
| Variant axes | Today, Months, Year, On-scrolling | N/A | ❌ |
| Theme support | Light & Dark (theme color frame present) | N/A | ❌ |
| Tooltip layer | Present (dedicated frame) | N/A | ❌ |

### Issues Found
- No Dart file exists for the `Timestamp` component
- All 13+ Figma variants (combinations of Today/Months/Year boolean flags + On-scrolling state) are unimplemented
- Two distinct design concerns are specified: **Timestamp theme color** (light/dark theming) and **Tooltips** — neither is addressed
- The component appears to support at minimum 3 display modes: today label, month display, and year display — each with a static and scrolling state

### Recommendations
- Create a `TimestampWidget` Flutter widget with the following boolean parameters: `isToday`, `showMonths`, `showYear`, `isOnScrolling`
- Implement light and dark theme color variants using the design token values from the "Timestamp theme color" Figma frame
- Implement the tooltip overlay behavior tied to the `On-scrolling=True` state
- Request untruncated Figma spec data to retrieve exact hex colors, font sizes, font weights, padding, and border-radius values before implementation