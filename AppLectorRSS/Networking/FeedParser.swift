//
//  FeedParser.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 12/3/22.
//

import Foundation

class FeedParser: NSObject {

    struct TagKeys {

        static let feed = "feed"
        static let entry = "entry"
        static let title = "title"
        static let published = "published"
        static let updatedDate = "updated"
        static let content = "content"
        static let link = "id"
        
    }

    var feed: Feed?
    var xmlString: String = ""
    var currentEntry: Entry?
    var xmlParser: XMLParser?

    init(withXMLData xml: Data) {
        xmlParser = XMLParser(data: xml)
    }

    func parse() -> Void {
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
}

extension FeedParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlString = ""
        if elementName == TagKeys.feed {
            feed = Feed(context: CoreDataManager.shared.persistentContainer.viewContext)
        } else if elementName == TagKeys.entry {
            currentEntry = Entry(context: CoreDataManager.shared.persistentContainer.viewContext)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlString += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentEntry != nil {
            if elementName == TagKeys.title {
                currentEntry?.title = xmlString
            } else if elementName == TagKeys.entry {
                feed?.entries?.insert(currentEntry!)
                currentEntry = nil
            } else if elementName == TagKeys.published {
                currentEntry?.published = Date.theVergeRSSDateFormatter.date(from: xmlString)
            } else if elementName == TagKeys.updatedDate {
                currentEntry?.updatedDate = Date.theVergeRSSDateFormatter.date(from: xmlString)
            } else if elementName == TagKeys.content {
                currentEntry?.content = xmlString
            } else if elementName == TagKeys.link {
                currentEntry?.link = xmlString
            }
        } else {
            if elementName == TagKeys.updatedDate {
                feed?.updatedDate = Date.theVergeRSSDateFormatter.date(from: xmlString)
            }
        }
    }
}
