import XCTest

/// Small helpers shared by the UI tests, so each test reads as a
/// sequence of user actions instead of raw element lookups.
extension XCUIApplication {
    /// A task row, located by the title it was created with.
    func taskRow(_ title: String) -> XCUIElement {
        buttons["taskRow_\(title)"]
    }

    /// Opens the add-task sheet, types the title and saves.
    func addTask(_ title: String) {
        buttons["addTaskButton"].tap()

        let field = textFields["taskTitleField"]
        XCTAssertTrue(field.waitForExistence(timeout: 5), "Add-task sheet should open")
        field.tap()
        field.typeText(title)

        buttons["saveTaskButton"].tap()
    }
}
