import SwiftUI

struct SettingsView: View {
    @AppStorage("grayscaleEnabled") private var grayscaleEnabled: Bool = false

    var body: some View {
        Form {
            Toggle("Enable Grayscale Mode", isOn: $grayscaleEnabled)
        }
        .navigationTitle("Settings")
    }
}