struct PickerSectionView: View {
    @ObservedObject var viewModel: StructureViewModel
    @Binding var selectedSpace: Space?
    @Binding var selectedGroup: Group?
    @Binding var selectedSet: SetItem?

    var body: some View {
        VStack(spacing: 12) {
            if viewModel.spaces.isEmpty {
                ProgressView("Loading spaces…")
            } else {
                Picker("Space", selection: $selectedSpace) {
                    ForEach(viewModel.spaces) { space in
                        Text(space.name).tag(Optional(space))
                    }
                }
                .pickerStyle(.menu)

                if let groups = selectedSpace?.groups {
                    Picker("Group", selection: $selectedGroup) {
                        ForEach(groups) { group in
                            Text(group.name).tag(Optional(group))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("Select a space first").foregroundColor(.secondary)
                }

                if let sets = selectedGroup?.sets {
                    Picker("Set", selection: $selectedSet) {
                        ForEach(sets) { set in
                            Text(set.title).tag(Optional(set))
                        }
                    }
                    .pickerStyle(.menu)
                } else if selectedGroup != nil {
                    Text("Loading sets…").foregroundColor(.secondary)
                } else {
                    Text("Select a group first").foregroundColor(.secondary)
                }
            }
        }
    }
}
