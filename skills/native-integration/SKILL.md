---
name: native-integration
description: Review React Native native-module, permission, and background-task work. Use when integrating platform APIs, camera, biometrics, files, or reviewing a bridge or Turbo Module boundary.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, native, permissions, turbo-modules]
---

# Native Integration Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Integrating a native module, Turbo Module, or platform API
- Requesting permissions, or handling camera, biometrics, files, or location
- Adding a background task or a native listener
- Reviewing a change that crosses the JavaScript and native boundary

## Guidance

### Permissions

- [ ] Permission is requested at the moment of use, not on app launch or screen mount
- [ ] Denied, restricted, and revoked states have a path that does not crash or loop the prompt
- [ ] The user can continue without the permission, or is told what is blocked and how to enable it in Settings
- [ ] iOS usage strings explain the specific purpose; Android declares only the permissions the feature uses

**Incorrect:**
```tsx
useEffect(() => {
  request(PERMISSIONS.IOS.CAMERA);
}, []);
```

**Correct:**
```tsx
async function onTakePhoto() {
  const status = await check(PERMISSIONS.IOS.CAMERA);
  if (status === RESULTS.DENIED) {
    const next = await request(PERMISSIONS.IOS.CAMERA);
    if (next !== RESULTS.GRANTED) {
      setNeedsSettings(true);
      return;
    }
  }
  if (status === RESULTS.BLOCKED) {
    setNeedsSettings(true);
    return;
  }
  await openCamera();
}
```

### Native boundary

- [ ] The JavaScript API returns a result or a typed error; it does not throw an unstructured native exception into the screen
- [ ] A missing or old native implementation has a fallback (hide the feature, or use a supported path)
- [ ] Values crossing the bridge are serialisable; functions, class instances, and cyclic objects are not passed through
- [ ] Platform differences are explicit (`Platform.OS` or separate files), not assumed to match
- [ ] New Architecture interop is used when the app is on the New Architecture; the old bridge is not added for a new module without a reason

### Lifecycle

- [ ] Native listeners, sensors, and subscriptions are removed on unmount
- [ ] Background work respects OS limits (time, network, and user-visible purpose) and can be cancelled
- [ ] Work that must finish (upload, payment) is confirmed on the server, not only by a native callback
- [ ] Native UI that presents a modal or activity restores the React Native screen when it dismisses

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Requesting permission in `useEffect` on mount | Prompt before the user understands why; denial with no recovery | Request from the action that needs it, and handle denial |
| Treating "granted once" as permanent | Revoked or limited permission crashes the next call | Check status before every use |
| Passing a JS callback object into native and never removing it | Leak and calls after unmount | Subscribe with a cleanup function |
| Swallowing native errors as `catch {}` | The screen looks idle while the feature failed | Surface a typed error and a retry or fallback |

## Pitfalls

- Android may deliver a permission result after the activity restarts. Do not assume the component that called `request` is still mounted.
- iOS limited photo access is not the same as full access. Handle the limited set instead of treating it as denied or granted.
- Biometric success proves the device unlocked a key; it does not by itself prove the server accepted the user. Confirm the session server-side.
- A native module that touches UI or sensors must run on the platform's main thread. A background-thread call can crash or silently drop the event.
- File URIs from the camera or picker are often temporary. Copy what you must keep, and do not log the path if it contains user content.
