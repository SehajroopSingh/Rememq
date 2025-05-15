//
//  GlassBackground.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/13/25.
//


import SwiftUI

import SwiftUI

struct GlassBackground: View {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.3
    var blurRadius: CGFloat = 20

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.white.opacity(opacity))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .blur(radius: blurRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
    }
}
