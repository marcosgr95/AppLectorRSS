//
//  EntryListViewController.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 10/3/22.
//

import UIKit

class EntryListViewController: UIViewController, EntryListPresenterDelegate {

    // MARK: - IBOutlets

    @IBOutlet var entriesTableView: UITableView!
    @IBOutlet var lastUpdateLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!

    // MARK: - Variables

    var entries = [Entry]()
    var feed: Feed?
    let presenter: EntryListPresenter = EntryListPresenter()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(self)
        setUpTableView()
        setUpSearchBar()
        applyStyles()
        readFeed()
    }

    // MARK: - Private methods

    private func applyStyles() {
        title = "The Verge RSS Feed"
    }

    private func createRefreshControl() {
        entriesTableView.refreshControl = UIRefreshControl()
        entriesTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        entries = []
        searchBar.text = ""
        searchBar.resignFirstResponder()
        entriesTableView.reloadData()
        readFeed()
    }

    private func readFeed() {
        self.entriesTableView.refreshControl?.beginRefreshing()
        Task {
            do {
                try await presenter.readFeed()
                DispatchQueue.main.async {
                    self.entriesTableView.refreshControl?.endRefreshing()
                }
            } catch {
                showNetworkingErrorAlert(.badRequest)
            }
        }
    }

    private func setLastUpdate() {
        lastUpdateLabel.text = "Last update: \(Date.humanFriendlyDateFormat.string(from: feed?.updatedDate ?? Date()))"
    }

    private func setUpSearchBar() {
        searchBar.delegate = self
    }

    private func setUpTableView() {
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
        entriesTableView.register(UINib(nibName: EntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        createRefreshControl()
    }

    // MARK: - EntryListPresenterDelegate methods

    private func displayEntries(_ entries: [Entry], updateLastUpdate: Bool = true) {
        DispatchQueue.main.async {
            self.entries = entries.sorted(by: <)
            self.entriesTableView.reloadData()
            self.setLastUpdate()
        }
    }

    /***
     Method to display a feed after the API call
     */
    func presentFeed(_ feed: Feed?, _ error: NetworkingError?) {
        Task {
            if let error = error {
                self.showNetworkingErrorAlert(error)
            }
            self.feed = feed
            displayEntries(Array(feed?.entries ?? []))
        }
    }

    /***
     Method to present an entry's detail
     */
    func presentDetail(entry: Entry) {
        let detailVC = EntryDetailViewController(entry: entry)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    /***
     Method to display an array of entries after the searching by title
     */
    func presentEntries(_ entries: [Entry]) {
        displayEntries(entries, updateLastUpdate: false)
    }

}

extension EntryListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.presentFilteredResults(queryText: searchText)
    }
}
