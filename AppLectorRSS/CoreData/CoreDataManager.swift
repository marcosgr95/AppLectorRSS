//
//  CoreDataManager.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 11/3/22.
//

import Foundation
import CoreData

class CoreDataManager {

    public static let shared = CoreDataManager()

    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
