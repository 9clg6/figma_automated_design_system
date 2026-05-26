### Status: NOT_IMPLEMENTED

### Component: Radio buttons

> ⚠️ **Note:** Despite the component name being "❖ Radio buttons", the Figma JSON payload actually describes a **Progress Indicators** page (`❖ Progress indicators`). The audit below reflects what is actually specified in the JSON.

---

### Variants Coverage
| Figma Variant | Flutter Implementation |
|---|---|
| Linear progress indicator (base) | ❌ Not implemented |
| Progress = 25% | ❌ Not implemented |
| Progress = 50% | ❌ Not implemented |
| Progress = 75% | ❌ Not implemented |
| Progress = 100% | ❌ Not implemented |
| 19 additional variants (truncated) | ❌ Not implemented |

---

### Property Comparison
| Property | Figma | Flutter | Match |
|----------|-------|---------|-------|
| Component type | Linear Progress Indicator | — | ❌ |
| Container width | 1012px | — | ❌ |
| Container height | 907px | — | ❌ |
| Corner radii | Defined (truncated) | — | ❌ |
| Fill/background color | Style-referenced (truncated) | — | ❌ |
| Layout mode | Defined (truncated) | — | ❌ |
| Layout padding | Defined (truncated) | — | ❌ |
| Progress states | 25%, 50%, 75%, 100% | — | ❌ |

---

### Issues Found
- **No Dart files exist** for this component — zero implementation present.
- **Component name mismatch:** The Figma node is labelled "Radio buttons" but the page spec describes `Progress Indicators`. This suggests either a mis-mapping in the design system extraction pipeline or a stale/incorrect page reference.
- All visual properties (colors, radii, fill styles, spacing, typography) are **truncated** in the spec — full values could not be audited.
- At least **24 variants** are defined in Figma with no Flutter counterpart.

---

### Recommendations
1. **Resolve the naming conflict** — confirm whether this ticket targets Radio Buttons or Progress Indicators, and correct the Figma extraction mapping accordingly.
2. **Re-export the full Figma spec** without truncation to capture exact hex colors, corner radii, padding values, and typography for both components.
3. **Implement the Progress Indicator widget** covering all 5+ progress states (25 %, 50 %, 75 %, 100 % and any animated/indeterminate variant) using Flutter's `LinearProgressIndicator` as a base, styled to match Figma fill tokens.
4. **Implement Radio Buttons** as a separate component if it is genuinely missing, covering at minimum: unselected, selected, disabled-unselected, and disabled-selected states.
5. **Register both components** in the Linagora Design System token/theme layer to consume the correct color style references from Figma.