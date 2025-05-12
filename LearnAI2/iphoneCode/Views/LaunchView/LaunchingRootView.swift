//
//  LaunchingRootView.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 5/10/25.
//
import SwiftUI

struct LaunchingRootView: View {
    @State private var isActive = true
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    @StateObject var structureViewModel = StructureViewModel()  // ✅ shared instance


    var body: some View {
        content
            .environmentObject(structureViewModel)  // ✅ inject into the environment
            .onAppear {
                structureViewModel.loadStructure()
                dashboardViewModel.loadDashboard()
            }
    }

    @ViewBuilder
    var content: some View {
        ZStack {
            RootView()
                .opacity(isActive ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: isActive)

            if isActive {
                AnimatedSplashView(isActive: $isActive)
                    .transition(.opacity)
            }
        }
    }

    }

