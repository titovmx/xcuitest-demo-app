# iOS To-Do App + XCUITest

A deliberately small **SwiftUI** to-do app with a **XCUITest** UI suite that runs on
the iOS Simulator. The point is not the app - it is how the UI automation is
structured: stable accessibility identifiers, explicit waits, and a CI pipeline
that builds and tests with no manual setup.

## App under test

Two screens, no persistence:

- **Task list** (`TaskListView`) - shows the tasks, an empty state when there are
  none. Tap a row to toggle it done, swipe a row to delete it, `+` opens the
  add-task sheet.
- **Add task** (`AddTaskView`) - a sheet with a title field. `Save` is disabled
  until the title has non-blank text; `Cancel` discards.

State lives in `TaskStore`, an `@Observable` class holding an array in memory.
Nothing is written to disk, so every launch starts empty and each UI test is
independent - no cleanup step, no shared state between tests.

## Tests

`ToDoAppUITests` - 7 tests across two files:

**`TaskListUITests`**
- empty state is shown on a fresh launch
- an added task appears in the list
- tapping a task toggles it done and back
- swipe-to-delete removes it and brings the empty state back

**`AddTaskUITests`**
- `Save` is disabled until a title is entered
- `Cancel` discards the typed task
- saving two tasks keeps both

`XCUIApplication+ToDo.swift` holds the shared helpers (`addTask`, `taskRow`), so
tests read as user actions rather than element lookups.

## What this demonstrates

- **Stable locators** - every control exposes an `accessibilityIdentifier`
  (`addTaskButton`, `taskTitleField`, `saveTaskButton`, `taskRow_<title>`), so
  tests never depend on visible text or layout.
- **State as accessibility value** - a row publishes `done` / `not done` through
  `accessibilityValue`, so the test asserts on state instead of scraping an icon.
- **Explicit waits** - `waitForExistence(timeout:)` everywhere, never `sleep`.
- **Project as code** - the Xcode project is generated from [`project.yml`](project.yml)
  with [XcodeGen](https://github.com/yonsm/XcodeGen), so it is reviewable and CI
  regenerates it. The `.xcodeproj` is gitignored.
- **Simulator CI** - GitHub Actions picks an available iPhone simulator
  dynamically and runs the suite headless.

## Running locally

Requires Xcode 16+ and XcodeGen (`brew install xcodegen`).

```bash
xcodegen generate
xcodebuild test \
  -project ToDoApp.xcodeproj \
  -scheme ToDoApp \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  CODE_SIGNING_ALLOWED=NO
```

Or open `ToDoApp.xcodeproj` in Xcode and press Cmd-U.

## Tech

Swift 5, SwiftUI, Observation, XCUITest, XcodeGen, GitHub Actions.
