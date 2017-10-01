//
//  TableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 26/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var newFeed: NSArray = []
    var url: NSURL = NSURL()
    
    var channelName = String()
    var channelURL = String()
    var channelRow = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        let name = channelName
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker?.send(builder as! [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = nil
        self.navigationItem.title = self.channelName
        self.url = NSURL(string: self.channelURL)!
        self.tableView.separatorStyle = .none
        
        addGradientBackground()
        
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.color = UIColor.black
        indicator.center = self.view.center
        self.tableView.backgroundView!.addSubview(indicator)
        indicator.startAnimating()
       
        let overlay = UIView()
        overlay.frame = self.view.bounds
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.3
        self.tableView.backgroundView!.addSubview(overlay)
        
        DispatchQueue.main.async(execute: {
            
            self.loadRSS(self.url as URL)

            DispatchQueue.main.async(execute: {
                
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 70
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
                indicator.stopAnimating()
                overlay.removeFromSuperview()
            })
            
        })
        
    }
    
    func loadRSS(_ data: URL) {
        
        let myParser: XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        self.newFeed = myParser.feeds
    }
    
    func addGradientBackground() -> () {
        
        let backgroundView = UIView()
        let background = CAGradientLayer().turquoiseColor()
        let deviceScale = UIScreen.main.scale
        background.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width * deviceScale, height: view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            cell.alpha = 1
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openPage" {
            
            var selectedSpecialCaseContent = String()
            
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFTitle: String = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "title") as! String
            let selectedFContent: String = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "description") as! String
            let selectedURL: String = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "link") as! String
            let selectedImage: String = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "enclosure") as! String
            let selectedPubDate: String = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "pubDate") as! String
            
            if channelName == "The Irrawaddy" || channelName == "Radio Free Asia (RFA)" || channelName == "DVB" || channelName == "Karen News" || channelName == "Popular News" {
                selectedSpecialCaseContent = (newFeed[(indexPath as NSIndexPath).row] as AnyObject).object(forKey: "content:encoded") as! String
            }
            
            let fpvc: PageViewController = segue.destination as! PageViewController
            
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        
        var removedExtraLineTitle = (newFeed.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
            removedExtraLineTitle = removedExtraLineTitle?.replacingOccurrences(of: "\n", with: "")
        
        cell.textLabel?.text = removedExtraLineTitle
        cell.textLabel?.font = UIFont(name:"Zawgyi-One", size:15)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        return cell
    }
    

    
}
