//
//  Feed.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import CoreData
import Foundation

@objc(Feed)
class Feed: NSManagedObject {

    // MARK: - Variables

    @NSManaged var link: String?
    @NSManaged var title: String?
    @NSManaged var updatedDate: Date?

    // MARK: - Relationships

    @NSManaged var entries: Set<Entry>?

    // MARK: - Fetch requests

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

}
