//
//  FeedParser.swift
//  AppLectorRSS
//
//  Created by Marcos García Rouco on 12/3/22.
//

import Foundation

class FeedParser: NSObject {

    // Keys to iterate over the xml feed

    struct TagKeys {

        static let content = "content"
        static let entry = "entry"
        static let feed = "feed"
        static let link = "id"
        static let published = "published"
        static let title = "title"
        static let updatedDate = "updated"
        
    }

    // MARK: - Variables

    var currentEntry: Entry?
    var feed: Feed?
    var xmlParser: XMLParser?
    var xmlString: String = ""

    // MARK: - Init method

    init(withXMLData xml: Data) {
        xmlParser = XMLParser(data: xml)
    }

    // MARK: - Methods

    func parse() -> Void {
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
}

extension FeedParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlString = ""
        // When we find a <feed> or <entry> tag, we must create an entity of one of those types
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
        // If currentEntry isn't nil it means we're reading a <entry> tag
        if currentEntry != nil {
            if elementName == TagKeys.title {
                currentEntry?.title = xmlString
            } else if elementName == TagKeys.entry {
                feed?.entries?.insert(currentEntry!)
                // Once the <entry> tag has reached its end, currentEntry is set to nil
                currentEntry = nil
            } else if elementName == TagKeys.published {
                currentEntry?.published = Date.theVergeRSSDateFormatter.date(from: xmlString)
            } else if elementName == TagKeys.updatedDate {
                currentEntry?.updatedDate = Date.theVergeRSSDateFormatter.date(from: xmlString)
            } else if elementName == TagKeys.content {
                currentEntry?.content = xmlString
                guard
                    let pictureLink = xmlString.getEmbeddedImgLink(),
                    let url = URL(string: pictureLink)
                else { return }
                currentEntry?.picture = try? Data.init(contentsOf: url)
            } else if elementName == TagKeys.link {
                currentEntry?.link = xmlString
            }
        } else {
            // Otherwise, we're dealing with a <feed> tag
            if elementName == TagKeys.updatedDate {
                feed?.updatedDate = Date.theVergeRSSDateFormatter.date(from: xmlString)
            }
        }
    }
}
