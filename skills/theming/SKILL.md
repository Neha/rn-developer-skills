---
name: theming
description: Apply colour scheme, dark mode, and theme tokens in React Native. Use when adding a theme, supporting dark mode, or replacing hardcoded colours.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, theming, dark-mode]
---

# Theming Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Adding light and dark appearance, or an in-app theme choice
- Replacing hardcoded colours in a screen or component
- Checking contrast, status bar, and images against the active scheme

Contrast and dynamic type also belong to [accessibility](../accessibility/SKILL.md). User-facing theme names belong to [i18n-and-localization](../i18n-and-localization/SKILL.md).

## Guidance

### Tokens

- [ ] Components take colours from theme tokens, not from hex values in the component file
- [ ] The same token names exist for every supported scheme
- [ ] An in-app choice (system, light, dark) is persisted and applied on the next cold start

**Incorrect:**
```tsx
<Text style={{ color: '#111' }}>Total</Text>
```

**Correct:**
```tsx
const colors = useThemeColors();
<Text style={{ color: colors.textPrimary }}>Total</Text>
```

### System appearance

- [ ] When the user has not chosen a scheme, the app follows the system colour scheme and updates if the system changes while the app is open
- [ ] The status bar and navigation chrome stay readable on both schemes
- [ ] Images and icons that assume a light background have a dark-scheme variant, or are simple enough to sit on either

### Contrast

- [ ] Text and icons on the themed background meet the contrast used for the rest of the app (see [accessibility](../accessibility/SKILL.md))
- [ ] State is not communicated by a theme colour alone

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Reading the colour scheme once at launch | The UI stays light after the user switches the system to dark | Subscribe to scheme changes |
| A second palette inside one feature | Dark mode fixes miss that feature | Use the shared tokens |

## Pitfalls

- A snapshot test locked to one scheme will not catch a dark-mode contrast failure.
- Native screens and webviews do not inherit JS theme tokens unless they are given the same colours.
