//
//  StringExtension.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 13/3/22.
//

import Foundation

extension String {

    func getEmbeddedImgLink () -> String? {
        let pattern: String = "src=\".*\""
        let range: NSRange = NSRange(location: 0, length: self.utf16.count)
        let regex = try? NSRegularExpression(pattern: pattern)

        return regex?
            .firstMatch(in: self, options: [], range: range)
            .map({String(self[Range($0.range, in: self)!])})?
            .replacingOccurrences(of: "src=", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }

}
