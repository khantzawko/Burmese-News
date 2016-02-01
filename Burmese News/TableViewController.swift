//
//  TableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 26/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, NSXMLParserDelegate {
    
    var newFeed: NSArray = []
    var url: NSURL = NSURL()
    
    var channelName = String()
    var channelURL = String()
    var channelRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = nil
        self.navigationItem.title = self.channelName
        self.url = NSURL(string: self.channelURL)!
        self.tableView.separatorStyle = .None
        
        addGradientBackground()
        
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.color = UIColor.blackColor()
        indicator.center = self.view.center
        self.tableView.backgroundView!.addSubview(indicator)
        indicator.startAnimating()
       
        let overlay = UIView()
        overlay.frame = self.view.bounds
        overlay.backgroundColor = UIColor.blackColor()
        overlay.alpha = 0.3
        self.tableView.backgroundView!.addSubview(overlay)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            self.loadRSS(self.url)

            dispatch_sync(dispatch_get_main_queue(), {
                
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 70
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.separatorStyle = .SingleLine
                self.tableView.reloadData()
                indicator.stopAnimating()
                overlay.removeFromSuperview()
            })
            
        })
        
    }
    
    func loadRSS(data: NSURL) {
        
        let myParser: XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        self.newFeed = myParser.feeds
    }
    
    func addGradientBackground() -> () {
        
        let backgroundView = UIView()
        let background = CAGradientLayer().turquoiseColor()
        let deviceScale = UIScreen.mainScreen().scale
        background.frame = CGRectMake(0.0, 0.0, view.frame.size.width * deviceScale, view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.alpha = 1
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openPage" {
            
            var selectedSpecialCaseContent = String()
            
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFTitle: String = newFeed[indexPath.row].objectForKey("title") as! String
            let selectedFContent: String = newFeed[indexPath.row].objectForKey("description") as! String
            let selectedURL: String = newFeed[indexPath.row].objectForKey("link") as! String
            let selectedImage: String = newFeed[indexPath.row].objectForKey("enclosure") as! String
            let selectedPubDate: String = newFeed[indexPath.row].objectForKey("pubDate") as! String
            
            if channelName == "The Irrawaddy" || channelName == "Radio Free Asia (RFA)" || channelName == "DVB" || channelName == "Karen News" || channelName == "Popular News" {
                selectedSpecialCaseContent = newFeed[indexPath.row].objectForKey("content:encoded") as! String
            }
            
            let fpvc: PageViewController = segue.destinationViewController as! PageViewController
            
            fpvc.selectedFeedTitle = selectedFTitle
            fpvc.selectedFeedContent = selectedFContent
            fpvc.selectedFeedURL = selectedURL
            fpvc.selectedFeedImage = selectedImage
            fpvc.selectedFeedPubDate = selectedPubDate
            if channelName == "The Irrawaddy" || channelName == "Radio Free Asia (RFA)" || channelName == "DVB" || channelName == "Karen News" || channelName == "Popular News" {
                fpvc.selectedFeedIrrwaddyContent = selectedSpecialCaseContent
            }
            fpvc.selectedChannelName = channelName
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFeed.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        var removedExtraLineTitle = newFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
            removedExtraLineTitle = removedExtraLineTitle?.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        cell.textLabel?.text = removedExtraLineTitle
        cell.textLabel?.font = UIFont(name:"Zawgyi-One", size:15)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        return cell
    }
    

    
}
