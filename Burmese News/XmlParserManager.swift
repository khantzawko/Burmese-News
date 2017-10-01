//
//  XmlParserManager.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 27/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()
    var fspecialDescription = NSMutableString()
    var fimage = NSMutableString()
    var fdate = NSMutableString()
    var feedEnclosure = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        feeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        
        if (element as NSString).isEqual(to: "entry") || (element as NSString).isEqual(to: "item"){
            elements = NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            link = NSMutableString()
            fdescription = NSMutableString()
            fspecialDescription = NSMutableString()
            fimage = NSMutableString()
            feedEnclosure = NSMutableString()
            fdate = NSMutableString()
        }
        
        if element.isEqual(to: "enclosure") {
            let imgLink: String = attributeDict["url"]!
            feedEnclosure.append(imgLink)
        } else {
            feedEnclosure.append("\n")
        }
        
        if element.isEqual(to: "link") {
            if attributeDict["rel"] == "alternate" {
                let alternatelink: String = attributeDict["href"]!
                link.append(alternatelink)
            }
        }
        
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqual(to: "entry") || (elementName as NSString).isEqual(to: "item"){
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            
            if fspecialDescription != "" {
                elements.setObject(fspecialDescription, forKey: "content:encoded" as NSCopying)
            }
            
            if feedEnclosure != "" {
                elements.setObject(feedEnclosure, forKey: "enclosure" as NSCopying)
            }
            
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }

            feeds.add(elements)
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element.isEqual(to: "title") {
            ftitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "description") || element.isEqual(to: "content") || element.isEqual(to: "summary") {
            fdescription.append(string)
        } else if element.isEqual(to: "content:encoded"){
            fspecialDescription.append(string)
        } else if element.isEqual(to: "pubDate") || element.isEqual(to: "dc:date") || element.isEqual(to: "published")  {
            fdate.append(string)
        }
    }

}
