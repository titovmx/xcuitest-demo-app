import SwiftUI

/// Second screen: a sheet for entering a new task title.
/// Save is disabled until the title has some non-blank text.
struct AddTaskView: View {
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("What needs to be done?", text: $title)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("taskTitleField")
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelTaskButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title)
                        dismiss()
                    }
                    .disabled(!canSave)
                    .accessibilityIdentifier("saveTaskButton")
                }
            }
        }
    }
}

#Preview {
    AddTaskView { _ in }
}
