//
//  EntryListViewController+TableView.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation
import UIKit

extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as? EntryCell
        else { return UITableViewCell() }

        cell.configure(
            pictureURL: entries[indexPath.row].content?.getEmbeddedImgLink(),
            title: entries[indexPath.row].title,
            description: entries[indexPath.row].content
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO
    }

}
