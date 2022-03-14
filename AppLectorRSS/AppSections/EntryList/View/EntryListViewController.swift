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

    // MARK: - Variables

    var entries = [Entry]()
    var feed: Feed?
    let presenter: EntryListPresenter = EntryListPresenter()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(self)
        setUpTableView()
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
    
    func setUpTableView() {
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
        entriesTableView.register(UINib(nibName: EntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        createRefreshControl()
    }

    // MARK: - EntryListPresenterDelegate methods

    func presentFeed(_ feed: Feed?, _ error: NetworkingError?) {
        Task {
            if let error = error {
                self.showNetworkingErrorAlert(error)
            }
            self.feed = feed
            self.entries = Array(feed?.entries ?? []).sorted(by: <)
            DispatchQueue.main.async {
                self.entriesTableView.reloadData()
                self.setLastUpdate()
            }
        }
    }

    func presentDetail(entry: Entry) {
        let detailVC = EntryDetailViewController(entry: entry)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
