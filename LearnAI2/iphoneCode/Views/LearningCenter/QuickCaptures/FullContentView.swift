//
//  FullContentView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/31/25.
//
import SwiftUI

struct FullContentView: View {
    let content: String

    var body: some View {
        ScrollView {
            Text(content)
                .padding()
        }
        .navigationTitle("Full Content")
    }
}
