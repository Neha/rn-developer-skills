---
name: i18n-and-localization
description: Review React Native localization for extracted strings, plurals, locale-aware formatting, and RTL layout. Use when adding a locale, implementing RTL, or auditing translation readiness.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, i18n, l10n, rtl]
---

# i18n and Localization Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Adding a locale or extracting user-facing copy
- Implementing right-to-left layout
- Formatting dates, numbers, or currencies
- Auditing a screen for translation readiness

## Guidance

### Strings

- [ ] User-facing copy comes from the translation catalog, including placeholders, alerts, and accessibility labels
- [ ] Plurals, gender, and context use a message format that selects the right form (ICU-style), not string concatenation
- [ ] The source string is a complete sentence so translators can reorder words
- [ ] A missing key falls back to the default locale and does not render the key or `undefined`

**Incorrect:**
```tsx
<Text>{count} {count === 1 ? 'item' : 'items'} in your ${'bag'}</Text>
```

**Correct:**
```tsx
<Text>{t('cart.summary', { count })}</Text>
```

### Formatting

- [ ] Dates, times, numbers, and currencies use the active locale, not a hardcoded `en-US` pattern
- [ ] Business deadlines use the server timezone (see `critical-rules`); only display formatting uses the locale
- [ ] The locale used for formatting is the app locale, which may differ from the device locale when the user picks a language in-app

### Layout

- [ ] Layout uses start/end (or equivalent logical edges), not left/right, so RTL mirrors rows, icons, and chevrons
- [ ] Text containers can grow; labels are not fixed to the English string width
- [ ] Text still fits and remains readable at large dynamic type with the longest supported translation
- [ ] Directional icons (back, next) flip in RTL; icons that depict an object do not

### Verification

- [ ] A pseudo-locale (padded, accented strings) is checked for overflow and truncation
- [ ] At least one RTL locale is checked for alignment, icons, and text entry
- [ ] The locale from a link or stored preference is validated against the supported set before it is applied

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Concatenating translated fragments | Word order breaks in other languages | One message with named placeholders |
| Assuming left-to-right padding and chevrons | RTL screens point the wrong way | Logical start/end, and flip directional icons |
| Fixed-width labels sized for English | German or Arabic clips or overflows | Let text wrap or grow, and test the longest locale |
| Taking a locale from a URL and applying it raw | Unexpected locale or injection into formatters | Allow only known locale codes |

## Pitfalls

- iOS and Android expose the device locale differently, and a per-app language (iOS) does not match Android's per-app locale API. Read the platform value once and store the app's choice separately.
- An in-app language switch must update already-mounted screens. Changing a module-level string table without re-rendering leaves the old language on screen.
- Bidirectional text (an English name inside an Arabic sentence) needs the platform's bidi handling. Do not force the whole paragraph to one direction if it mixes scripts.
- Pseudo-locale overflow often shows up only inside a row that also has an icon and a badge. Test those rows, not only a full-width text block.
