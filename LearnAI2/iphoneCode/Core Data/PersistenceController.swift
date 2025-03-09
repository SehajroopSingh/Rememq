//
//  PersistenceController.swift
//  ReMEMq
//
//  Created by Sehaj Singh on 3/7/25.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ReMEMqModel") // Match this with .xcdatamodeld file
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Error loading Core Data store: \(error)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    func save() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Error saving Core Data: \(error)")
            }
        }
    }
}
