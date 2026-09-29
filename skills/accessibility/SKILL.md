---
name: accessibility
description: Review React Native code for screen-reader support, labels and roles, touch targets, focus order, colour contrast, and dynamic type. Use when building UI, reviewing components, or auditing a screen for accessibility.
version: 1.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, accessibility, a11y, screen-reader]
---

# Accessibility Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Building or reviewing any interactive UI
- Auditing a screen for screen-reader and assistive-technology support
- Verifying an app meets accessibility expectations before release

## Severity

- **Merge-blocking:** an interactive control this diff adds has no accessible name.
- **Should-fix:** target size, contrast, dynamic type, and focus order.

## Guidance

### Labels & Roles

- [ ] An interactive control has an accessible name: its visible text, or an `accessibilityLabel` when the visible content is only an icon
- [ ] Do not repeat the visible text in `accessibilityLabel`
- [ ] Every interactive element has an `accessibilityRole` (button, link, header, etc.)
- [ ] State changes use `accessibilityState` (disabled, selected, expanded)
- [ ] Images have an `accessibilityLabel`, or are marked `accessibilityElementsHidden` if decorative
- [ ] Dynamic content changes are announced (`AccessibilityInfo.announceForAccessibility`)

**Incorrect:**
```tsx
<TouchableOpacity onPress={onDelete}>
  <Icon name="trash" />
</TouchableOpacity>
```

**Correct:**
```tsx
<TouchableOpacity
  onPress={onDelete}
  accessibilityLabel="Delete item"
  accessibilityRole="button"
  hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
>
  <Icon name="trash" />
</TouchableOpacity>
```

### Touch & Focus

- [ ] Touch targets are at least 44×44pt on iOS and 48×48dp on Android
- [ ] Focus order follows reading order. In an RTL layout that order starts at the trailing edge (see [i18n-and-localization](../i18n-and-localization/SKILL.md))

### Visual

- [ ] Colour is not the only indicator of state (add icon, text, or pattern)
- [ ] Text scales with the system font-size preference

### Verification

- [ ] Tested with VoiceOver (iOS) and TalkBack (Android)

## Pitfalls

- Labels that describe the element type ("button") instead of its purpose ("Delete item") give screen-reader users no useful information.
- Forgetting `accessibilityState={{ disabled: true }}` on a disabled control means the screen reader still announces it as an active button.
- Relying on colour alone (e.g. red for error) excludes colour-blind users; pair it with an icon or text.
- Fixed font sizes break layouts when users increase system text size — test at large dynamic type settings.
