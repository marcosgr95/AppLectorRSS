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

    @NSManaged var published: Date?
    @NSManaged var updatedDate: Date?
    @NSManaged var content: String?
    @NSManaged var title: String?
    @NSManaged var link: String?

    // MARK: - Fetch requests

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

}

extension Entry: Comparable {
    
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        guard let lPublished = lhs.published else { return false }
        guard let rPublished = rhs.published else { return true }
        return lPublished > rPublished
    }

}
