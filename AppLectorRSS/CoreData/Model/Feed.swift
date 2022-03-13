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

    @NSManaged var updatedDate: Date?
    @NSManaged var title: String?
    @NSManaged var link: String?

    // MARK: - Relationships

    @NSManaged var entries: Set<Entry>?

}
