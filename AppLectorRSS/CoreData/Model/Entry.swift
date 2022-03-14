//
//  Entry.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import CoreData
import Foundation

@objc(Entry)
class Entry: NSManagedObject {

    // MARK: - Variables

    @NSManaged var content: String?
    @NSManaged var link: String?
    @NSManaged var picture: Data?
    @NSManaged var published: Date?
    @NSManaged var title: String?
    @NSManaged var updatedDate: Date?

    // MARK: - Fetch requests

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @nonobjc public class func fetchRequestByTitle(_ titleQuery: String?) -> NSFetchRequest<Entry> {
        guard let titleQuery = titleQuery, !titleQuery.isEmpty else {
            return fetchRequest()
        }

        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", titleQuery)
        return fetchRequest
    }

}

extension Entry: Comparable {
    
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        guard let lPublished = lhs.published else { return false }
        guard let rPublished = rhs.published else { return true }
        return lPublished > rPublished
    }

}
