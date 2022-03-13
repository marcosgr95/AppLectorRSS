//
//  ViewController.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 10/3/22.
//

import CoreData
import UIKit
import XMLParsing

class ViewController: UIViewController {

    var entries = Set<Entry>()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                guard let url = URL(string: "https://www.theverge.com/apple/rss/index.xml") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                let parser = FeedParser(withXMLData: data)
                entries = parser.parse()?.entries ?? Set()
                CoreDataManager.shared.saveContext()
            } catch {
                print("anything \(error)")
            }
        }
    }

}

@objc(Feed)
class Feed: NSManagedObject {

    // MARK: - Variables

    @NSManaged var updatedDate: Date?
    @NSManaged var title: String?
    @NSManaged var link: String?

    // MARK: - Relationships

    @NSManaged var entries: Set<Entry>?

}

@objc(Entry)
class Entry: NSManagedObject {

    @NSManaged var published: Date?
    @NSManaged var updatedDate: Date?
    @NSManaged var content: String?
    @NSManaged var title: String?
    @NSManaged var link: String?

}

