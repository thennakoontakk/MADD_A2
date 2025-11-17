## Understanding
- The app builds but hits EXC_BAD_ACCESS at launch on tvOS. This usually points to a runtime-only issue (unsupported API on platform version, animation/transition misuse, invalid style APIs, or a force-unwrapped resource).
- Current tvOS code uses custom animations and UI styles that may be unsupported or fragile on tvOS 14.

## Read-Only Diagnosis Steps
1. Run the app with console output to capture the crash backtrace and symbol names.
2. Stream device logs to identify the first exception site and any runtime “unavailable” API messages.
3. Confirm tvOS SDK and deployment target (14.0) and reconcile with APIs used (ProgressView styling, transition, animation modifiers).

## Targeted Fixes (to apply after approval)
1. ProgressView styling
   - Replace `LinearProgressViewStyle(tint:)` with `.accentColor(...)` and default `ProgressViewStyle()` to avoid runtime style crashes on tvOS.
2. Animation safety
   - Remove `.animation(...)` modifiers tied to computed booleans; use `withAnimation { ... }` inside button actions and simple `.animation(.easeInOut, value: isSelected)` if needed.
   - In `DashboardView`, replace `.transition(.opacity.combined(with: .move(edge: .bottom)))` with `.opacity` only.
3. Focus and selection
   - Keep `.focusable(true)` only on `Button` wrappers.
   - Ensure no state cycles: selection updates `selectedProfile` only; avoid simultaneous rapid changes.
4. Defensive guards
   - Ensure summary views don’t force unwrap or assume non-empty arrays; use `if let` (already done).

## Verification
- Rebuild for tvOS Simulator.
- Launch using console to ensure no crash and verify selection, summary display, and dashboard navigation.

## Deliverables
- Updated tvOS views with safer animations and styles.
- Crash logs summary and confirmation of successful app launch post-fix.

## Notes
- If the crash persists after these changes, we will temporarily stub the selection screen to a minimal static View to isolate the offending line via binary search on changes.