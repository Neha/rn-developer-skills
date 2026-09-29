---
name: notifications
description: Handle push and local notifications, permission timing, tap routing, and payload privacy. Use when adding notifications, handling a tap, or reviewing background delivery.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, notifications, push]
---

# Notifications Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Registering for push or scheduling a local notification
- Handling a tap that opens a screen from the background or a killed app
- Reviewing what the payload contains and when permission is requested

Permission prompts in general belong to [native-integration](../native-integration/SKILL.md). Whether a deep link target is allowed belongs to [security](../security/SKILL.md).

## Guidance

### Permission and registration

- [ ] Notification permission is requested when the user asks for alerts, not at first launch
- [ ] Denied and revoked states skip registration and do not loop the prompt
- [ ] The device token is sent to the server after it changes, and removed from the server on sign-out

### Delivery

- [ ] Foreground, background, and killed-app taps all open the same destination
- [ ] The destination params are validated before navigation (see [security](../security/SKILL.md))
- [ ] A tap that arrives before navigation is ready is stored and consumed once, not dropped and not applied twice
- [ ] Android channels exist for the categories the user can tell apart; iOS uses a purpose the user can understand

**Incorrect:**
```tsx
function onNotification(remoteMessage) {
  navigation.navigate(remoteMessage.data.screen, remoteMessage.data);
}
```

**Correct:**
```tsx
function onNotification(remoteMessage) {
  const route = parseNotificationRoute(remoteMessage.data);
  if (!route) return;
  navigation.navigate(route.name, route.params);
}
```

### Privacy

- [ ] The visible title and body, and the data payload, contain no payment data, tokens, or more personal detail than the user needs to recognise the alert
- [ ] Marketing or non-essential alerts are not scheduled when consent is off (see [security](../security/SKILL.md))

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Navigating from the raw payload | Opens an arbitrary screen or crashes on a missing param | Parse into a fixed set of routes |
| Registering a new token without deleting the old one on logout | The previous user receives the next user's alerts | Delete the token server-side on sign-out |

## Pitfalls

- A killed-app tap is delivered on the next cold start, which is a different lifecycle from a foreground event.
- Background delivery limits differ by platform; a handler that does network work can be suspended before it finishes.
