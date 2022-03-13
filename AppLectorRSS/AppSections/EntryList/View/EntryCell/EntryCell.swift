//
//  EntryCell.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import UIKit

class EntryCell: UITableViewCell {

    // MARK: - Constants

    static let reuseIdentifier: String = "EntryCell"

    // MARK: - IBOutlets

    @IBOutlet var entryPicture: UIImageView!
    @IBOutlet var entryTitle: UILabel!
    @IBOutlet var entryDescription: UILabel!
    
    // MARK: - Public methods

    public func configure(pictureURL: String?, title: String?, description: String?) {
        entryTitle.text = title
        entryDescription.text = description?.htmlToString
        entryPicture.load(urlString: pictureURL)
    }

    
}
