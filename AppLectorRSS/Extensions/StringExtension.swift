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

    func htmlToAttributedString(withTrimmedTags: Bool = false) -> NSAttributedString? {
        guard
            let data = (withTrimmedTags ? self.withTrimmedTags : self)?.data(using: .utf8)
        else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }

    func htmlToString(withTrimmedTags: Bool = false) -> String {
        return htmlToAttributedString(withTrimmedTags: withTrimmedTags)?.string ?? ""
    }

    var withTrimmedTags: String? {
        let pattern: String = "(<figure>|<\\/figure>|<img.*\\/>|<figcaption>.*</figcaption>)"
        let range: NSRange = NSRange(location: 0, length: self.utf16.count)
        let regex = try? NSRegularExpression(pattern: pattern)
        let mutableString = NSMutableString(string: self)

        regex?
            .replaceMatches(in: mutableString, options: .reportProgress, range: range, withTemplate: "")
        return mutableString as String
    }
}
