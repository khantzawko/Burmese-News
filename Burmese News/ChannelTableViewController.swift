//
//  NewsChannelTableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 28/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class ChannelTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var channelNames = ["Voice of America (VOA)", "DVB", "The Irrawaddy", "Radio Free Asia (RFA)", "Mizzima", "The Voice", "Myanmar Celebrity", "Popular News", "Karen News", "Panglong"]
    
    var channelURLs = ["http://burmese.voanews.com/api/epiqq", "http://burmese.dvb.no/feed", "http://burma.irrawaddy.org/feed", "http://www.rfa.org/burmese/news/RSS", "http://mizzimaburmese.com/rss.xml", "http://www.thevoicemyanmar.com/index.php/news/local?format=feed&limitstart=", "http://feeds.feedburner.com/MyanmarCelebrity?format=xml", "http://popularmyanmar.com/afpopular/?feed=rss2", "http://kicnews.org/feed/", "http://panglongburmese.blogspot.com/feeds/posts/default"]
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 70
        self.tableView.opaque = true
        
        // to remove previous nsUserDefault values in the list while updating names and urls
        
        if (defaults.objectForKey("Name") != nil) && (defaults.objectForKey("URL") != nil) {
            defaults.removeObjectForKey("Name")
            defaults.removeObjectForKey("URL")
        }

        
        if (defaults.objectForKey("channelNames") != nil) {       // object name is not empty
            channelNames = defaults.objectForKey("channelNames") as? [String] ?? [String]()
            channelURLs = defaults.objectForKey("channelURLs") as? [String] ?? [String]()
        }
        
        addGradientBackground()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        longpress.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longpress)
    }
    
    func addGradientBackground() -> () {
        
        let backgroundView = UIView()
        let background = CAGradientLayer().turquoiseColor()
        let deviceScale = UIScreen.mainScreen().scale
        background.frame = CGRectMake(0.0, 0.0, view.frame.size.width * deviceScale, view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
        
    }

    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        var locationInView = longPress.locationInView(self.tableView)
        var indexPath = self.tableView.indexPathForRowAtPoint(locationInView)
        
        func snapshopOfCell(inputView: UIView) -> UIView {
            UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
            inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
            let cellSnapshot : UIView = UIImageView(image: image)
            cellSnapshot.layer.masksToBounds = false
            cellSnapshot.layer.cornerRadius = 0.0
            cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
            cellSnapshot.layer.shadowRadius = 5.0
            cellSnapshot.layer.shadowOpacity = 0.4
            return cellSnapshot
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot = snapshopOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                self.tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
            
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                
                swap(&channelNames[indexPath!.row], &channelNames[Path.initialIndexPath!.row])
                swap(&channelURLs[indexPath!.row], &channelURLs[Path.initialIndexPath!.row])
                
                defaults.setObject(channelNames, forKey: "channelNames")
                defaults.setObject(channelURLs, forKey: "channelURLs")
                
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
            
            
        default:
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = channelNames[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        if segue.identifier == "openChannel" {
            
            let tvc: TableViewController = segue.destinationViewController as! TableViewController
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            tvc.channelName = channelNames[indexPath.row]
            tvc.channelURL = channelURLs[indexPath.row]
            tvc.channelRow = indexPath.row
        }
    }
    
    
}
