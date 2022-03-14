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

    func applyStyles() {
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

    func setLastUpdate() {
        lastUpdateLabel.text = "Last update: \(Date.humanFriendlyDateFormat.string(from: feed?.updatedDate ?? Date()))"
    }

    func setUpSearchBar() {
        searchBar.delegate = self
    }

    func setUpTableView() {
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
        entriesTableView.register(UINib(nibName: EntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        createRefreshControl()
    }

    // MARK: - EntryListPresenterDelegate methods

    fileprivate func displayEntries(_ entries: [Entry], updateLastUpdate: Bool = true) {
        self.entries = entries.sorted(by: <)
        DispatchQueue.main.async {
            self.entriesTableView.reloadData()
            self.setLastUpdate()
        }
    }

    func presentFeed(_ feed: Feed?, _ error: NetworkingError?) {
        Task {
            if let error = error {
                self.showNetworkingErrorAlert(error)
            }
            self.feed = feed
            displayEntries(Array(feed?.entries ?? []))
        }
    }

    func presentDetail(entry: Entry) {
        let detailVC = EntryDetailViewController(entry: entry)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func presentEntries(_ entries: [Entry]) {
        displayEntries(entries, updateLastUpdate: false)
    }

}

extension EntryListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.presentFilteredResults(queryText: searchText)
    }
}
