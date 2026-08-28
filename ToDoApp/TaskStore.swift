import Foundation
import Observation

/// One to-do item.
struct TaskItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isDone = false
}

/// In-memory list of tasks. Nothing is persisted, so every app launch
/// starts from the same state and UI tests stay independent.
@Observable
final class TaskStore {
    private(set) var tasks: [TaskItem] = []

    func add(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.append(TaskItem(title: trimmed))
    }

    func toggle(_ task: TaskItem) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
