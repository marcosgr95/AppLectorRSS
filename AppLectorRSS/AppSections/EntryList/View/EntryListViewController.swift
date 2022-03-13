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

    // MARK: - Variables

    var entries = [Entry]()
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
        Task {
            do {
                try await presenter.readFeed()
                DispatchQueue.main.async {
                    self.entriesTableView.refreshControl?.endRefreshing()
                }
            } catch {
                // TODO
            }
        }
    }

    func setUpTableView() {
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
        entriesTableView.register(UINib(nibName: EntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EntryCell.reuseIdentifier)
        createRefreshControl()
    }

    // MARK: - EntryListPresenterDelegate methods

    func presentFeed(_ feed: Feed?) {
        Task {
            self.entries = Array(feed?.entries ?? []).sorted(by: <)
            self.entriesTableView.reloadData()
        }
    }

}
