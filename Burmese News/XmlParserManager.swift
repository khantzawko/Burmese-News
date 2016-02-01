//
//  XmlParserManager.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 27/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class XmlParserManager: NSObject, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
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
    func initWithURL(url :NSURL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(url :NSURL) {
        feeds = []
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName
        
        if (element as NSString).isEqualToString("entry") || (element as NSString).isEqualToString("item"){
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
        
        if element.isEqualToString("enclosure") {
            let imgLink: String = attributeDict["url"]!
            feedEnclosure.appendString(imgLink)
        } else {
            feedEnclosure.appendString("\n")
        }
        
        if element.isEqualToString("link") {
            if attributeDict["rel"] == "alternate" {
                let alternatelink: String = attributeDict["href"]!
                link.appendString(alternatelink)
            }
        }
        
    }

    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqualToString("entry") || (elementName as NSString).isEqualToString("item"){
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title")
            }
            
            if link != "" {
                elements.setObject(link, forKey: "link")
            }
            
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description")
            }
            
            if fspecialDescription != "" {
                elements.setObject(fspecialDescription, forKey: "content:encoded")
            }
            
            if feedEnclosure != "" {
                elements.setObject(feedEnclosure, forKey: "enclosure")
            }
            
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate")
            }

            feeds.addObject(elements)
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if element.isEqualToString("title") {
            ftitle.appendString(string)
        } else if element.isEqualToString("link") {
            link.appendString(string)
        } else if element.isEqualToString("description") || element.isEqualToString("content") || element.isEqualToString("summary") {
            fdescription.appendString(string)
        } else if element.isEqualToString("content:encoded"){
            fspecialDescription.appendString(string)
        } else if element.isEqualToString("pubDate") || element.isEqualToString("dc:date") || element.isEqualToString("published")  {
            fdate.appendString(string)
        }
    }

}
