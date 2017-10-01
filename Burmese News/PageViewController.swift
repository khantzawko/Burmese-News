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
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let name = selectedChannelName
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker?.send(builder as! [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = self.webView
        
        DispatchQueue.main.async(execute: {
                
            let feedContent:String

            self.selectedFeedImage = self.selectedFeedImage.replacingOccurrences(of: "\n", with: "")
            
            if self.selectedChannelName == "7 Day News"{
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0000", with: "")
                
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> <img src = \(self.selectedFeedImage) width = 100%> <br> <br> \(self.selectedFeedContent)"
                
                
            } else if self.selectedChannelName == "The Irrawaddy"{
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0000", with: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                var changeImageSize: String = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "width", with: "width = 100%")
                changeImageSize = changeImageSize.replacingOccurrences(of: "height", with: " ")

                feedContent = "<style> .date {color: dimgrey; font-size: 90%;} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>\(changeImageSize)"
                
            } else if self.selectedChannelName == "DVB" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0000", with: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "width", with: "width = 100%")
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "height", with: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedIrrwaddyContent)"
                
                
            } else if self.selectedChannelName == "Radio Free Asia (RFA)" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: "T", with: " ")
                self.selectedFeedPubDate = self.formatDateFromString("yyyy-MM-dd HH:mm:ssZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "img", with: "img width = 100%")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedIrrwaddyContent)"
                
            } else if self.selectedChannelName == "Voice of America (VOA)" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0630", with: "")
                
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> <img src = \(self.selectedFeedImage) width = 100%> <br> <br> \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "Panglong" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: "T", with: " ")
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: "-07:00", with: "Z")
                self.selectedFeedPubDate = self.formatDateFromString("yyyy-MM-dd HH:mm:ss.SSSZ", dateToString: self.selectedFeedPubDate)
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "margin-left", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "margin-right", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "width", with: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "height", with: " ")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "img", with: "img width = 100%")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p> \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "The Voice" {
                            
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0000", with: "")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "K2FeedImage\"><img src=", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "border", with: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "margin: 3px", with: "")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            } else if self.selectedChannelName == "Karen News" || self.selectedChannelName == "Popular News" {
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: " +0000", with: "")
                self.selectedFeedPubDate = self.formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "width", with: "width = 100%")
                self.selectedFeedIrrwaddyContent = self.selectedFeedIrrwaddyContent.replacingOccurrences(of: "height", with: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">Posted on: \(self.selectedFeedPubDate)</p>  \(self.selectedFeedIrrwaddyContent)"
                
            } else if self.selectedChannelName == "Myanmar Celebrity" {
                
                //2016-08-25T00:46:00.003-07:00
                
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: "T", with: " ")
                self.selectedFeedPubDate = self.selectedFeedPubDate.replacingOccurrences(of: "-07:00", with: "")

                self.selectedFeedPubDate = self.formatDateFromString("yyyy-MM-dd HH:mm:ss.SSS", dateToString: self.selectedFeedPubDate)

                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "img", with: "img width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "margin", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "border", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "width", with: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "height", with: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">\(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            } else {
        
                //self.selectedFeedPubDate = self.selectedFeedPubDate.stringByReplacingOccurrencesOfString(" +0000", withString: "")
                //self.selectedFeedPubDate = formatDateFromString("EEE, dd MMM yyyy HH:mm:ss", dateToString: self.selectedFeedPubDate)
                
                self.selectedFeedPubDate = ""
                
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "img", with: "img width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "margin", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "border", with: "")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "width", with: "width = 100%")
                self.selectedFeedContent = self.selectedFeedContent.replacingOccurrences(of: "height", with: " ")
                feedContent = "<style> .date {color: dimgrey; font-size: 90%} body {margin-left: 9px; margin-right: 9px; font-family: Zawgyi-One;}</style> <h3 style = 'color:black'>\(self.selectedFeedTitle)</h3> <p class = 'date' style=\"font-family: courier\">\(self.selectedFeedPubDate)</p>  \(self.selectedFeedContent)"
                
            }
                        
            DispatchQueue.main.async(execute: {
                
                let attributes = [
                    NSAttributedStringKey.foregroundColor: UIColor.black,
                    NSAttributedStringKey.font: UIFont(name: "Zawgyi-One", size: 16)!
                ]
                self.navigationController?.navigationBar.titleTextAttributes = attributes
                
                self.navigationItem.title = self.selectedFeedTitle
                self.webView?.loadHTMLString(feedContent, baseURL: nil)
            })
        })
    }
    
    func formatDateFromString(_ format: String, dateToString: String) -> String {
        
        var dateToString = dateToString.replacingOccurrences(of: "\n", with: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateToString)
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateToString = dateFormatter.string(from: date!)
        
        return dateToString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openWebPage" {
            
            let fwpvc: WebViewController = segue.destination as! WebViewController
            self.selectedFeedURL =  self.selectedFeedURL.replacingOccurrences(of: " ", with:"")
            self.selectedFeedURL =  self.selectedFeedURL.replacingOccurrences(of: "\n", with:"")
            self.selectedFeedURL =  self.selectedFeedURL.replacingOccurrences(of: "\t", with:"")
            self.selectedFeedURL =  self.selectedFeedURL.replacingOccurrences(of: "\t\t", with:"")

            fwpvc.feedURL = self.selectedFeedURL
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
