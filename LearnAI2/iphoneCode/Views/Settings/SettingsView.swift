//
//  SettingsView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/4/25.
//


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