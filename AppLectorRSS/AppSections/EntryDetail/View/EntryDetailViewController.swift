//
//  EntryDetailViewController.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 14/3/22.
//

import UIKit

class EntryDetailViewController: UIViewController, EntryDetailPresenterDelegate {

    // MARK: - IBOutlets

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - Variables

    var entry: Entry
    let presenter = EntryDetailPresenter()

    // MARK: - Init methods

    init(entry: Entry) {
        self.entry = entry
        super.init(nibName: "EntryDetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(self)
        configureNavigationBar()
        displayInfo()
    }

    // MARK: - Private methods

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "network"),
            style: .plain,
            target: self,
            action: #selector(openInBrowser)
        )
    }

    private func displayInfo() {
        titleLabel.text = entry.title
        descriptionLabel.text = entry.content?.htmlToString(withTrimmedTags: true)
        guard let imageData = entry.picture else {
            picture.image = UIImageView.defaultImage
            return
        }
        picture.image = UIImage(data: imageData)
    }

    @objc private func openInBrowser() {
        presenter.openInBrowser(urlString: entry.link)
    }

    // MARK: - EntryDetailPresenterDelegate

    func presentError(_ error: NetworkingError) {
        // TODO display alert
    }

}
