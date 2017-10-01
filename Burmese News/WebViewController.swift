//
//  File.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 27/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
        
    var feedWebView: UIWebView!
    
    var feedURL = ""
    
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
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Web View")
        
        let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker?.send(builder as! [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        feedWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        feedWebView.scalesPageToFit = true
        feedWebView.loadRequest(URLRequest(url: URL(string: feedURL)!))
        self.view = self.feedWebView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
