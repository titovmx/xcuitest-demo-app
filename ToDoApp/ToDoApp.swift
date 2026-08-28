import SwiftUI

@main
struct ToDoApp: App {
    @State private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            TaskListView(store: store)
        }
    }
}
