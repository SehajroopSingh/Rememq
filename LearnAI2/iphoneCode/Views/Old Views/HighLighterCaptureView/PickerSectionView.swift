//////
//////  PickerSectionView.swift
//////  ReMEMq
//////
//////  Created by Sehaj Singh on 5/28/25.
//////
////import SwiftUI
////
////struct PickerSectionView: View {
////    @ObservedObject var viewModel: StructureViewModel
////    @Binding var selectedSpace: Space?
////    @Binding var selectedGroup: Group?
////    @Binding var selectedSet: SetItem?
////
////    var body: some View {
////        VStack(spacing: 12) {
////            if viewModel.spaces.isEmpty {
////                ProgressView("Loading spaces…")
////            } else {
////                Picker("Space", selection: $selectedSpace) {
////                    ForEach(viewModel.spaces) { space in
////                        Text(space.name).tag(Optional(space))
////                    }
////                }
////                .pickerStyle(.menu)
////
////                if let groups = selectedSpace?.groups {
////                    Picker("Group", selection: $selectedGroup) {
////                        ForEach(groups) { group in
////                            Text(group.name).tag(Optional(group))
////                        }
////                    }
////                    .pickerStyle(.menu)
////                } else {
////                    Text("Select a space first").foregroundColor(.secondary)
////                }
////
////                if let sets = selectedGroup?.sets {
////                    Picker("Set", selection: $selectedSet) {
////                        ForEach(sets) { set in
////                            Text(set.title).tag(Optional(set))
////                        }
////                    }
////                    .pickerStyle(.menu)
////                } else if selectedGroup != nil {
////                    Text("Loading sets…").foregroundColor(.secondary)
////                } else {
////                    Text("Select a group first").foregroundColor(.secondary)
////                }
////            }
////        }
////    }
////}
//import SwiftUI
//
//struct PickerSectionView: View {
//    @ObservedObject var viewModel: StructureViewModel
//    @Binding var selectedSpace: Space?
//    @Binding var selectedGroup: Group?
//    @Binding var selectedSet: SetItem?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 24) {
//            // — Space Pills —
//            Text("Choose a Space")
//                .font(.subheadline).fontWeight(.semibold)
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 12) {
//                    ForEach(viewModel.spaces) { space in
//                        pillButton(
//                            title: space.name,
//                            isSelected: selectedSpace?.id == space.id
//                        ) {
//                            selectedSpace = space
//                            selectedGroup = nil
//                            selectedSet = nil
//                        }
//                    }
//                }
//            }
//
//            // — Group Pills or Hint —
//            if let groups = selectedSpace?.groups {
//                Text("Choose a Group")
//                    .font(.subheadline).fontWeight(.semibold)
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(groups) { group in
//                            pillButton(
//                                title: group.name,
//                                isSelected: selectedGroup?.id == group.id
//                            ) {
//                                selectedGroup = group
//                                selectedSet = nil
//                            }
//                        }
//                    }
//                }
//            } else {
//                Text("Select a space first")
//                    .italic()
//                    .foregroundColor(.secondary)
//            }
//
//            // — Set Pills or Hint —
//            if let sets = selectedGroup?.sets {
//                Text("Choose a Set")
//                    .font(.subheadline).fontWeight(.semibold)
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(sets) { set in
//                            pillButton(
//                                title: set.title,
//                                isSelected: selectedSet?.id == set.id
//                            ) {
//                                selectedSet = set
//                            }
//                        }
//                    }
//                }
//            } else if selectedGroup != nil {
//                Text("Loading sets…")
//                    .italic()
//                    .foregroundColor(.secondary)
//            } else {
//                Text("Select a group first")
//                    .italic()
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding(20)
//        .background(Color(.systemBackground))
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
//        .padding(.horizontal, 16)
//    }
//
//    @ViewBuilder
//    private func pillButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Text(title)
//                .font(.footnote).fontWeight(.medium)
//                .padding(.vertical, 8)
//                .padding(.horizontal, 16)
//                .background(isSelected ? Color.accentColor : Color(.secondarySystemFill))
//                .foregroundColor(isSelected ? .white : .primary)
//                .cornerRadius(12)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
////}
//import SwiftUI
//
//struct PickerSectionView: View {
//    @ObservedObject var viewModel: StructureViewModel
//    @Binding var selectedSpace: Space?
//    @Binding var selectedGroup: Group?
//    @Binding var selectedSet: SetItem?
//
//    var body: some View {
//        HStack(spacing: 8) {
//            // Space menu
//            Menu {
//                ForEach(viewModel.spaces) { space in
//                    Button(space.name) {
//                        selectedSpace = space
//                        selectedGroup = nil
//                        selectedSet = nil
//                    }
//                }
//            } label: {
//                Label(selectedSpace?.name ?? "Space", systemImage: "folder")
//                    .lineLimit(1)
//            }
//
//            Divider().frame(height: 24)
//
//            // Group menu
//            if let groups = selectedSpace?.groups {
//                Menu {
//                    ForEach(groups) { group in
//                        Button(group.name) {
//                            selectedGroup = group
//                            selectedSet = nil
//                        }
//                    }
//                } label: {
//                    Label(selectedGroup?.name ?? "Group", systemImage: "square.stack")
//                        .lineLimit(1)
//                }
//            } else {
//                Label("Group", systemImage: "square.stack")
//                    .foregroundColor(.secondary)
//            }
//
//            Divider().frame(height: 24)
//
//            // Set menu
//            if let sets = selectedGroup?.sets {
//                Menu {
//                    ForEach(sets) { set in
//                        Button(set.title) {
//                            selectedSet = set
//                        }
//                    }
//                } label: {
//                    Label(selectedSet?.title ?? "Set", systemImage: "doc.text")
//                        .lineLimit(1)
//                }
//            } else {
//                Label("Set", systemImage: "doc.text")
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 12)
//        .background(
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .fill(Color.white.opacity(0.15))
//                .background(.ultraThinMaterial)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//        )
//        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
//        .padding(.horizontal, 16)
//    }
//}
import SwiftUI

struct PickerSectionView: View {
    @ObservedObject var viewModel: StructureViewModel
    @Binding var selectedSpace: Space?
    @Binding var selectedGroup: Group?
    @Binding var selectedSet: SetItem?

    var body: some View {
        HStack(spacing: 8) {
            // Space menu
            Menu {
                ForEach(viewModel.spaces) { space in
                    Button(space.name) {
                        selectedSpace = space
                        selectedGroup = nil
                        selectedSet = nil
                    }
                }
            } label: {
                Label(selectedSpace?.name ?? "Space", systemImage: "folder")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider().frame(height: 24)

            // Group menu
            if let groups = selectedSpace?.groups {
                Menu {
                    ForEach(groups) { group in
                        Button(group.name) {
                            selectedGroup = group
                            selectedSet = nil
                        }
                    }
                } label: {
                    Label(selectedGroup?.name ?? "Group", systemImage: "square.stack")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                Label("Group", systemImage: "square.stack")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider().frame(height: 24)

            // Set menu
            if let sets = selectedGroup?.sets {
                Menu {
                    ForEach(sets) { set in
                        Button(set.title) {
                            selectedSet = set
                        }
                    }
                } label: {
                    Label(selectedSet?.title ?? "Set", systemImage: "doc.text")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                Label("Set", systemImage: "doc.text")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.15))
                .background(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
    }
}
