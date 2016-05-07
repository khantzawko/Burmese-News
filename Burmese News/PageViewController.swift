//
//  FeedPageViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 27/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIWebViewDelegate {
    
    //@IBOutlet weak var myWebView: UIWebView!
    
    var webView: UIWebView!
    
    var selectedFeedTitle = String()
    var selectedFeedContent = String()
    var selectedFeedURL = String()
    var selectedFeedImage = String()
    var selectedFeedPubDate = String()
    var selectedChannelName = String()
    var selectedFeedIrrwaddyContent = String()
    
    var element = NSString()
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func viewWillAppear(animated: Bool) {
        let name = selectedChannelName
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view = self.webView
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
            let feedContent:String

            self.selectedFeedImage = self.selectedFeedImage.stringByReplacingOccurrencesOfString("\n", withString: "")
            
            if self.selectedChannelName == "7 Day News"{
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> <img src = \(self.selectedFeedImage) width = 100%> <br> <br> \(self.selectedFeedContent)"
                
                
            } else if self.selectedChannelName == "The Irrawaddy"{
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                var changeImageSize: String = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("620px", withString: "100%")
                changeImageSize = changeImageSize.stringByReplacingOccurrencesOfString("610", withString: "100%")
                changeImageSize = changeImageSize.stringByReplacingOccurrencesOfString("height", withString: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>\(changeImageSize)"
                
            } else if self.selectedChannelName == "DVB" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("width", withString: "width = 100%")
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("height", withString: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedIrrwaddyContent)"
                
                
            } else if self.selectedChannelName == "Radio Free Asia (RFA)" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString("T", withString: " ")
                self.selectedFeedPubDate = self.formatDateFromString("yyyy-MM-dd HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("img", withString: "img width = 100%")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedIrrwaddyContent)"
                
            } else if self.selectedChannelName == "Voice of America (VOA)" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0630", withString: "")
                
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> <img src = \(self.selectedFeedImage) width = 100%> <br> <br> \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "Panglong" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString("T", withString: " ")
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString("-07:00", withString: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("yyyy-MM-dd HH:mm:ss.SSSZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("margin-left", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("margin-right", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("width", withString: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("height", withString: " ")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("img", withString: "img width = 100%")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "The Voice" {
                            
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("K2FeedImage\"><img src=", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("border", withString: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("margin: 3px", withString: "")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "Karen News" || self.selectedChannelName == "Popular News" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("width", withString: "width = 100%")
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.stringByReplacingOccurrencesOfString("height", withString: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>  \(self.selectedFeedIrrwaddyContent)"
                
            } else if self.selectedChannelName == "Myanmar Celebrity" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" PST", withString: "")
                self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" PDT", withString: "")

                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)

                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("img", withString: "img width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("margin", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("border", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("width", withString: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("height", withString: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">\(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            } else {
        
                //self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                //self.selectedFeedPubDate = formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                
                self.selectedFeedPubDate = ""
                
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("img", withString: "img width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("margin", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("border", withString: "")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("width", withString: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.stringByReplacingOccurrencesOfString("height", withString: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">\(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            }
                        
            dispatch_async(dispatch_get_main_queue(), {
                
                let attributes = [
                    NSForegroundColorAttributeName: UIColor.blackColor(),
                    NSFontAttributeName: UIFont(name: "Zawgyi-One", size: 16)!
                ]
                self.navigationController?.navigationBar.titleTextAttributes = attributes
                
                self.navigationItem.title = self.selectedFeedTitle
                self.webView?.loadHTMLString(feedContent, baseURL: nil)
            })
        })
    }
    
    func formatDateFromString(let format: String, dateToString: String) -> String {
        
        var dateToString = dateToString.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.dateFromString(dateToString)
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        dateToString = dateFormatter.stringFromDate(date!)
        
        return dateToString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "openWebPage" {
            
            let fwpvc: WebViewController = segue.destinationViewController as! WebViewController
            self.selectedFeedURL =  self.selectedFeedURL.stringByReplacingOccurrencesOfString(" ", withString:"")
            self.selectedFeedURL =  self.selectedFeedURL.stringByReplacingOccurrencesOfString("\n", withString:"")
            self.selectedFeedURL =  self.selectedFeedURL.stringByReplacingOccurrencesOfString("\t", withString:"")
            self.selectedFeedURL =  self.selectedFeedURL.stringByReplacingOccurrencesOfString("\t\t", withString:"")

            fwpvc.feedURL = self.selectedFeedURL
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
