//
//  CombinedSpacesView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/20/25.
//
import SwiftUI

struct CombinedSpacesView: View {
    @State private var selected = 0
    var body: some View {
        VStack {
            Picker("Mode", selection: $selected) {
                Text("My Spaces").tag(0)
                Text("Shared").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            if selected == 0 {
                SpacesView()
            } else {
                SharedSpacesView()
            }
        }
    }
}
