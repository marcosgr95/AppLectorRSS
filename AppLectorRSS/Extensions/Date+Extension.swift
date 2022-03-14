//
//  Date+Extension.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation

extension Date {

    /***
     Formatter to parse the dates sent by the RSS feed
     */
    static let theVergeRSSDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    /***
     Formatter to parse and display the dates in a more human-friendly way
     */
    static let humanFriendlyDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}
