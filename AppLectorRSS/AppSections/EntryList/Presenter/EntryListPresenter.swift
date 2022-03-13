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
            guard let url = URL(string: NetworkingConstants.theVergeRSSFeed)
            else {
                throw NetworkingError.badURL
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                throw NetworkingError.badRequest
            }
            let parser = FeedParser(withXMLData: data)
            parser.parse()
            
            CoreDataManager.shared.saveContext()
            view?.presentFeed(try CoreDataManager.shared.fetchFeed())
        } catch {
            print("anything \(error)")
            // TODO present the entries from the database while throwing an error, so presentEntries should return both an array of entries and an error (string, so as for the view to remain dumb)
            view?.presentFeed(try? CoreDataManager.shared.fetchFeed())
        }
    }

    public func setView(_ delegate: EntryListPresenterDelegate) {
        self.view = delegate
    }
}
