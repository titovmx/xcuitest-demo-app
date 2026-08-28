import XCTest

final class TaskListUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testEmptyStateIsShownOnFirstLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.staticTexts["emptyStateLabel"].waitForExistence(timeout: 5),
            "A fresh launch should show the empty state"
        )
    }

    func testAddedTaskAppearsInTheList() throws {
        let app = XCUIApplication()
        app.launch()
        app.addTask("buy milk")

        XCTAssertTrue(
            app.taskRow("buy milk").waitForExistence(timeout: 5),
            "The new task should be listed"
        )
        XCTAssertFalse(app.staticTexts["emptyStateLabel"].exists)
    }

    func testTappingTaskTogglesItDone() throws {
        let app = XCUIApplication()
        app.launch()
        app.addTask("walk the dog")

        let row = app.taskRow("walk the dog")
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertEqual(row.value as? String, "not done")

        row.tap()
        XCTAssertEqual(row.value as? String, "done")

        row.tap()
        XCTAssertEqual(row.value as? String, "not done")
    }

    func testSwipeDeleteRemovesTask() throws {
        let app = XCUIApplication()
        app.launch()
        app.addTask("read a book")

        let row = app.taskRow("read a book")
        XCTAssertTrue(row.waitForExistence(timeout: 5))

        row.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertTrue(
            app.staticTexts["emptyStateLabel"].waitForExistence(timeout: 5),
            "Deleting the only task should bring the empty state back"
        )
    }
}
