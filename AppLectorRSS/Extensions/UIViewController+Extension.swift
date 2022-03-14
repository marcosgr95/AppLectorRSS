//
//  UIViewController+Extension.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 14/3/22.
//

import UIKit

extension UIViewController {

    public func showAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    func showNetworkingErrorAlert(_ error: NetworkingError) {
        switch error {
        case .badRequest:
            showAlert(title: "Bad request", message: "No resource matches with what you're trying to retrieve")
        case .badURL:
            showAlert(title: "Bad URL", message: "The URL is corrupt or isn't reachable at the moment")
        case .corruptedData:
            showAlert(title: "Corrupted data", message: "The data can't be shown because it's corrupted")
        case .noLink:
            showAlert(title: "No link", message: "No link was found")
        }
    }
}
