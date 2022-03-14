//
//  EntryListPresenter.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation

protocol EntryListPresenterDelegate: AnyObject {
    func presentDetail(entry: Entry)
    func presentFeed(_ feed: Feed?, _ error: NetworkingError?)
    func presentEntries(_ entries: [Entry])
}

class EntryListPresenter {

    // MARK: - Delegates

    weak var view: EntryListPresenterDelegate?

    // MARK: - Public methods

    public func presentDetail(entry: Entry) {
        view?.presentDetail(entry: entry)
    }

    public func presentFilteredResults(queryText: String) {
        do {
            view?.presentEntries(try CoreDataManager.shared.fetchEntriesByTitle(queryText))
        } catch {
            fatalError("The Core Data stack hasn't been configured properly!!")
        }
    }

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

            // This method will trigger the creation of Core Data entities, hence the call to saveContext afterwards
            parser.parse()
            
            CoreDataManager.shared.saveContext()
            view?.presentFeed(try CoreDataManager.shared.fetchFeed(), nil)
        } catch let error as NetworkingError {
            view?.presentFeed(try? CoreDataManager.shared.fetchFeed(), error)
        } catch {
            view?.presentFeed(try? CoreDataManager.shared.fetchFeed(), NetworkingError.badURL)
        }
    }

    public func setView(_ delegate: EntryListPresenterDelegate) {
        self.view = delegate
    }
}
