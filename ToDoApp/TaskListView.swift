import SwiftUI

/// Main screen: the list of tasks. Tapping a row toggles it done,
/// swiping deletes it, the toolbar button opens the add-task sheet.
/// Every control has an accessibility identifier so UI tests can
/// target it without depending on layout.
struct TaskListView: View {
    let store: TaskStore
    @State private var isAddingTask = false

    var body: some View {
        NavigationStack {
            Group {
                if store.tasks.isEmpty {
                    ContentUnavailableView {
                        Label("No tasks yet", systemImage: "checklist")
                    } description: {
                        Text("Tap + to add your first task.")
                            .accessibilityIdentifier("emptyStateLabel")
                    }
                } else {
                    taskList
                }
            }
            .navigationTitle("To-Do")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add task", systemImage: "plus") { isAddingTask = true }
                        .accessibilityIdentifier("addTaskButton")
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView { title in store.add(title: title) }
            }
        }
    }

    private var taskList: some View {
        List {
            ForEach(store.tasks) { task in
                Button {
                    store.toggle(task)
                } label: {
                    HStack {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        Text(task.title)
                            .strikethrough(task.isDone)
                        Spacer()
                    }
                }
                .foregroundStyle(.primary)
                .accessibilityIdentifier("taskRow_\(task.title)")
                .accessibilityValue(task.isDone ? "done" : "not done")
            }
            .onDelete { offsets in store.delete(at: offsets) }
        }
        .accessibilityIdentifier("taskList")
    }
}

#Preview {
    TaskListView(store: TaskStore())
}
