//
//  EntryListPresenter.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation

protocol EntryListPresenterDelegate: AnyObject {
    func presentFeed(_ feed: Feed?)
}

class EntryListPresenter {

    // MARK: - Delegates

    weak var view: EntryListPresenterDelegate?

    // MARK: - Public methods

    public func readFeed() async throws {
        do {
            guard let url = URL(string: "https://www.theverge.com/apple/rss/index.xml") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let parser = FeedParser(withXMLData: data)
            let feed = parser.parse()
            CoreDataManager.shared.saveContext()
            view?.presentFeed(feed)
        } catch {
            print("anything \(error)")
            // TODO present the entries from the database while throwing an error, so presentEntries should return both an array of entries and an error
        }
    }

    public func setView(_ delegate: EntryListPresenterDelegate) {
        self.view = delegate
    }
}
