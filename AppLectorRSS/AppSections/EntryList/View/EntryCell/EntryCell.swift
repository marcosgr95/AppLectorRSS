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

    @IBOutlet var entryDescription: UILabel!
    @IBOutlet var entryPicture: UIImageView!
    @IBOutlet var entryTitle: UILabel!
    
    // MARK: - Public methods

    public func configure(picture: Data?, title: String?, description: String?) {
        entryTitle.text = title
        entryDescription.text = description?.htmlToString(withTrimmedTags: true)
        guard let imageData = picture else {
            entryPicture.image = UIImageView.defaultImage
            return
        }
        entryPicture.image = UIImage(data: imageData)
    }

    
}
