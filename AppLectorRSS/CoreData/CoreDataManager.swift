//
//  CoreDataManager.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 11/3/22.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Singleton pattern

    public static let shared = CoreDataManager()

    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AppLectorRSS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Fetch requests

    func fetchEntries() throws -> [Entry] {
        return try persistentContainer.viewContext.fetch(Entry.fetchRequest())
    }

    func fetchEntriesByTitle(_ title: String) throws -> [Entry] {
        return try persistentContainer.viewContext.fetch(Entry.fetchRequestByTitle(title))
    }

    func fetchFeed() throws -> Feed? {
        return try (persistentContainer.viewContext.fetch(Feed.fetchRequest())).last
    }
}
