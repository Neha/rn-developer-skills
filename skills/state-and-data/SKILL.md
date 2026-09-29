---
name: state-and-data
description: Review React Native data and state handling — one cache for server data, staleness, offline behaviour, network transitions, and transactions. Use when wiring up APIs, handling offline, or reviewing data flow.
version: 1.2.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, state, data, networking, offline]
---

# State and Data Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Wiring a screen up to an API
- Reviewing how server state is fetched, cached, and displayed
- Handling offline mode, network transitions, or flaky connections
- Implementing payments, checkout, or other critical transactions

## Severity

- **Merge-blocking:** a POST this diff adds is retried when the network returns, or a payment is treated as success from the client callback alone.
- **Should-fix:** cache freshness, optimistic updates, and empty-state copy.

## Guidance

### Server State

Keep server data in one cache. That cache may be the store the app already uses.

- [ ] Server data is not copied into a second `useState` that can drift from the cache
- [ ] Freshness is chosen per data type, rather than refetching on every mount
- [ ] An optimistic update rolls back when the request fails
- [ ] Loading and empty states are shown for the query this diff adds
- [ ] A failed query shows an error state. The fallback and retry policy are owned by [error-handling](../error-handling/SKILL.md)

**Incorrect:**
```tsx
const [users, setUsers] = useState([]);
useEffect(() => {
  fetch('/api/users').then(r => r.json()).then(setUsers);
}, []);
```

**Correct:**
```tsx
const { data: users } = useQuery({
  queryKey: ['users'],
  queryFn: () => api.getUsers(),
  staleTime: 5 * 60 * 1000,
});
```

### Form & Local State

Dirty form input, validation, and unsaved-change prompts are owned by [forms-and-validation](../forms-and-validation/SKILL.md).

- [ ] Non-form UI state is not reset by keyboard appearance or orientation change

### Offline & Network Transitions

- [ ] Clear offline indicator shown to the user
- [ ] Cached data shown for read operations when offline
- [ ] Destructive mutations require confirmation before queuing offline
- [ ] Mid-request network drop handled with a timeout, not an infinite spinner
- [ ] In-progress requests cancelled on screen unmount

**Incorrect:**
```tsx
// No timeout — hangs forever on a slow network
const data = await fetch('/api/items');
```

**Correct:**
```tsx
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 10000);
try {
  const data = await fetch('/api/items', { signal: controller.signal });
} catch (e) {
  if (e.name === 'AbortError') showTimeout();
  else showError(e);
} finally {
  clearTimeout(timeout);
}
```

### Transactions & Critical Actions

- [ ] Success confirmed server-side, not from a client callback alone
- [ ] Interruption handled (user kills the app mid-transaction)
- [ ] External redirects (OAuth, 3DS) return cleanly to the app
- [ ] POST requests this diff adds are not auto-retried when the network returns (this skill owns that rule)

**Incorrect:**
```tsx
const onPay = async () => {
  await paymentSDK.charge(amount);
  navigation.navigate('Success'); // assumes success from the SDK alone
};
```

**Correct:**
```tsx
const onPay = async () => {
  const sdkResult = await paymentSDK.charge(amount);
  const confirmed = await api.confirmPayment(sdkResult.transactionId);
  if (confirmed.status === 'success') {
    navigation.navigate('Success');
  } else {
    navigation.navigate('PaymentFailed', { reason: confirmed.reason });
  }
};
```

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| A second `useState` copy of server data | The screen and the cache disagree | Read from the one cache the app already uses |
| Global store for server data | Stale data, manual refetching | Let the query library own it |
| Direct fetch/axios in components | Untestable, no caching, repeated code | Abstract into query hooks |
| Fire-and-forget async | Silent failures | Always handle errors |
| Auto-retry POST on reconnect | Duplicate transactions | Retry only idempotent reads |

## Pitfalls

- `staleTime: 0` (the default in many libraries) refetches on every screen focus, wasting bandwidth and battery.
- Optimistic updates without rollback on error leave the UI in an impossible state.
- Not cleaning up an `AbortController` on unmount triggers a state update on an unmounted component.
- Showing stale cached data without an offline indicator makes users think it is current.
- Not storing transaction intent before starting means an app crash equals lost state.
