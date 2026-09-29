---
name: forms-and-validation
description: Review React Native forms for validation timing, keyboard handling, error focus, and preserved dirty state. Use when building or reviewing login, signup, checkout, settings, or multi-step forms.
version: 1.0.1
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, forms, validation, keyboard]
---

# Forms and Validation Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Building or reviewing a login, signup, checkout, settings, or other multi-field form
- Changing validation, keyboard behaviour, or submit handling
- Reviewing a wizard or multi-step flow that collects user input

## Guidance

### State

This skill owns whether dirty form input survives navigation. [critical-rules](../critical-rules/SKILL.md) only checks that unsaved input is not discarded silently.

- [ ] Each field has one source of truth; the screen does not mix uncontrolled inputs with a second copy of the same value
- [ ] Dirty values survive leaving the screen and coming back, including when the app is backgrounded mid-edit
- [ ] A submit in flight is not sent again (button ignores repeat presses; a failed POST is not auto-retried)
- [ ] Leaving with unsaved changes asks the user before discarding, when the data would be lost

### Validation

- [ ] Format checks run on blur or submit, not on every keystroke
- [ ] Server checks (taken email, payment decline) run on submit and map to the field they belong to
- [ ] The first invalid field is scrolled into view and focused
- [ ] Errors are text, not colour alone, and are announced to the screen reader
- [ ] The submit control shows a loading state and stays disabled only while the request is in flight, with a visible reason when it cannot be used

**Incorrect:**
```tsx
<TextInput
  value={email}
  onChangeText={(next) => {
    setEmail(next);
    setEmailError(isEmail(next) ? '' : 'Enter a valid email');
  }}
/>
```

**Correct:**
```tsx
<TextInput
  value={email}
  onChangeText={setEmail}
  onBlur={() => setEmailError(isEmail(email) ? '' : 'Enter a valid email')}
  accessibilityLabel="Email"
  keyboardType="email-address"
  autoCapitalize="none"
  textContentType="emailAddress"
/>
```

### Keyboard and platform input

- [ ] The focused field stays visible above the keyboard (keyboard avoiding view, or a scroll view that knows the keyboard inset)
- [ ] The keyboard type matches the field (email, phone, number, decimal)
- [ ] Secure fields use secure entry and do not log their values
- [ ] Autofill hints (`textContentType` / `autoComplete`) are set for credentials and contact fields
- [ ] A multi-step form keeps earlier steps' values until the whole flow finishes or the user cancels

### Accessibility

- [ ] Every input has a label
- [ ] The error is associated with its field and announced when it appears
- [ ] Focus moves to the error, or the error summary, after a failed submit

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Validating on every keystroke | The field is "wrong" before the user finishes typing | Validate on blur and on submit |
| Clearing the form when the screen blurs | Back navigation or a permission prompt wipes the draft | Keep draft state above the screen, or in a store that survives the pop |
| Disabling submit with no message | The user cannot tell what is missing | Keep submit available and show field errors, or explain the disabled state |
| Retrying a failed POST automatically | A payment or signup can be created twice | Retry only when the user asks, after confirming the server did not apply it |

## Pitfalls

- iOS and Android report keyboard height differently, and Android's `adjustResize` can double-shift a view that also uses a keyboard-avoiding wrapper. Test both.
- Numeric keyboards still allow paste of non-numeric text. Validate the value, not the keyboard.
- `secureTextEntry` can reset the cursor or clear the field on some Android versions when toggled. Test the show/hide password control.
- A wizard that stores steps only in screen state loses them when a step unmounts. Keep the draft in one place that outlives each step.
