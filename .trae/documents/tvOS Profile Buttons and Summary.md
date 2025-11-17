## Goal
- Make profiles in tvOS selection screen clickable buttons.
- On click, show the selected profile’s details and water summary on the same screen, with an option to open the dashboard.

## Files to Update
- `AquaLog-tvOS/AquaLogTV/Views/ProfileSelectionView.swift`
- (No new model requirements; uses `UserProfile` fields already present.)

## Implementation Steps
1. Wrap each profile card in a `Button` in the grid
   - Location: the `ForEach(profiles)` loop (`ProfileSelectionView.swift:31`).
   - Replace the current card stack with a `Button(action:) { ProfileCard(...) }`.
   - Maintain tvOS compatibility (use `Button`; do not use `onTapGesture`, which is unavailable on tvOS).

2. Track selection state
   - Add `@State private var selectedProfile: UserProfile?`.
   - In the `Button(action:)`, set `selectedProfile = profile` and (optionally) `focusedProfile = profile`.

3. Accent styling for selected card
   - Extend `ProfileCard` with an `isSelected: Bool` prop.
   - When selected:
     - Set text to blue accent (name, progress labels, status).
     - Apply blue border to selected card only.
     - Keep subtle scale/shadow to emphasize selection.

4. Show summary below the grid when a card is selected
   - Conditional section: `if let profile = selectedProfile { ... }`.
   - Present profile details and summary stats using existing `UserProfile` fields:
     - Daily Goal (`profile.dailyGoal`)
     - Current (`profile.currentProgress`)
     - Remaining (`profile.remainingAmount`)
     - Progress (`Int(profile.progressPercentage * 100))%`)
   - Provide a “View Dashboard” button that calls `onProfileSelected(profile)` to navigate.

5. Optional UX polish (tvOS-safe)
   - Keep `.focusable(true)` on buttons for remote navigation.
   - Start with no card selected; selection happens on click.

## Expected Result
- Profiles in the selection grid are clickable.
- Clicking a profile highlights it with a blue accent and shows a summary panel.
- Users can proceed to the dashboard via the “View Dashboard” button.

## Notes
- This uses only tvOS-supported interactions (`Button`, `.focusable`) and avoids unavailable gestures.
- No model/backend changes required; summary is derived from `UserProfile`.