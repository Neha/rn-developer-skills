---
name: state-and-data
description: Review React Native data and state handling — server state with a query library, caching and staleness, offline behaviour, network transitions, transactions, and loading/empty/error states. Use when wiring up APIs, handling offline, or reviewing data flow.
version: 1.0.0
tags: [react-native, state, data, networking, offline]
---

# State and Data Skill

## When to Use

- Wiring a screen up to an API
- Reviewing how server state is fetched, cached, and displayed
- Handling offline mode, network transitions, or flaky connections
- Implementing payments, checkout, or other critical transactions

## Guidance

### Server State

- [ ] Server state uses a query library (e.g. TanStack Query), not local `useState` for API data
- [ ] No server state duplicated into local state
- [ ] Appropriate `staleTime` set per data type (not the default 0 for everything)
- [ ] Mutations use optimistic updates (`onMutate`) where appropriate, with rollback on error
- [ ] Loading states shown (skeleton or spinner)
- [ ] Empty states handled (no blank screens)
- [ ] Error states handled, not just the happy path

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

- [ ] Form state preserved on navigation away and back
- [ ] State not reset by keyboard appearance or orientation change

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
- [ ] POST requests not auto-retried on network restore (avoids duplicates)

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
| `useState` + `useEffect` for API data | Race conditions, no cache, no retry | Use a query library |
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
