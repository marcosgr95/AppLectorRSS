//
//  EntryDetailPresenter.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 14/3/22.
//

import Foundation
import UIKit

protocol EntryDetailPresenterDelegate: AnyObject {
    func presentError(_ error: NetworkingError)
}

class EntryDetailPresenter {

    // MARK: - Variables

    weak var view: EntryDetailPresenterDelegate?

    // MARK: - Public methods

    public func openInBrowser(urlString: String?) {
        guard let urlString = urlString else {
            view?.presentError(NetworkingError.noLink)
            return
        }
        guard
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
        else {
            view?.presentError(NetworkingError.badURL)
            return
        }
        UIApplication.shared.open(url)
    }

    public func setView(_ delegate: EntryDetailPresenterDelegate) {
        self.view = delegate
    }

}
