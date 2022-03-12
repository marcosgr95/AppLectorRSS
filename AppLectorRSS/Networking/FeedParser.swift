//
//  FeedParser.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 12/3/22.
//

import Foundation

class FeedParser: NSObject {

    var feed: Feed?
    var xmlString: String = ""
    var currentEntry: Entry?
    var xmlParser: XMLParser?

    init(withXMLData xml: Data) {
        xmlParser = XMLParser(data: xml)
    }

    func parse() -> Feed? {
        xmlParser?.delegate = self
        xmlParser?.parse()
        return feed
    }
}

extension FeedParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlString = ""
        if elementName == "feed" {
            feed = Feed(context: CoreDataManager.shared.persistentContainer.viewContext)
        } else if elementName == "entry" {
            currentEntry = Entry(context: CoreDataManager.shared.persistentContainer.viewContext)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlString += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentEntry != nil {
            if elementName == "title" {
                currentEntry?.title = xmlString
            } else if elementName == "entry" {
                feed?.entries?.insert(currentEntry!)
                currentEntry = nil
            }
        }
    }
}
