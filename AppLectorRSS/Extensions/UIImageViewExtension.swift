//
//  UIImageViewExtension.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import UIKit

extension UIImageView {

    static var defaultImage: UIImage? {
        UIImage(systemName: "photo")?.withTintColor(.lightGray)
    }

    func load(urlString: String?) {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else { return }
        load(url: url)
    }

    func load(url: URL) {
        self.image = UIImageView.defaultImage
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
