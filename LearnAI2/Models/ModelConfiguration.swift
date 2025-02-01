//
//  ModeConfiguration.swift
//  LearnAI2
//
//  Created by Sehaj Singh on 2/1/25.
//

import SwiftData

public func ConfigureModelContainer() -> ModelContainer {
    let schema = Schema([
        // This is a Model from the app I'm working on
        Destination.self
    ])
    
    // Set up your ModelConfiguration however you need it
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError(error.localizedDescription)
    }
}
