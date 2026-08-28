import XCTest

final class AddTaskUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSaveIsDisabledUntilTitleIsEntered() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addTaskButton"].tap()

        let save = app.buttons["saveTaskButton"]
        XCTAssertTrue(save.waitForExistence(timeout: 5))
        XCTAssertFalse(save.isEnabled, "Save should be disabled for an empty title")

        app.textFields["taskTitleField"].tap()
        app.textFields["taskTitleField"].typeText("write tests")
        XCTAssertTrue(save.isEnabled, "Save should be enabled once a title is typed")
    }

    func testCancelDiscardsTheTask() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addTaskButton"].tap()

        let field = app.textFields["taskTitleField"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("discard me")
        app.buttons["cancelTaskButton"].tap()

        XCTAssertTrue(app.staticTexts["emptyStateLabel"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.taskRow("discard me").exists)
    }

    func testSavingTwoTasksKeepsBoth() throws {
        let app = XCUIApplication()
        app.launch()
        app.addTask("first task")
        app.addTask("second task")

        XCTAssertTrue(app.taskRow("first task").waitForExistence(timeout: 5))
        XCTAssertTrue(app.taskRow("second task").exists)
    }
}
