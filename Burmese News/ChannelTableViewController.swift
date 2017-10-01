//
//  NewsChannelTableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 28/7/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class ChannelTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var channelNames = ["7 Day News", "Voice of America (VOA)", "DVB", "The Irrawaddy", "Radio Free Asia (RFA)", "Mizzima", "The Voice", "Myanmar Celebrity", "Popular News", "Karen News", "Panglong"]
    
    var channelURLs = ["http://www.7daydaily.com/feed/category/12/feed", "http://burmese.voanews.com/api/epiqq", "http://burmese.dvb.no/feed", "http://burma.irrawaddy.org/feed", "http://www.rfa.org/burmese/news/RSS", "http://mizzimaburmese.com/rss.xml", "http://www.thevoicemyanmar.com/index.php/news/local?format=feed&limitstart=", "http://www.myanmarcelebrity.tv/feeds/posts/default", "http://popularmyanmar.com/afpopular/?feed=rss2", "http://kicnews.org/feed/", "http://panglongburmese.blogspot.com/feeds/posts/default"]
    
    var defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        let name = self.navigationItem.title!
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker?.send(builder as! [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 70
        self.tableView.isOpaque = true
        
        // to remove previous nsUserDefault values in the list while updating names and urls
        
        if (defaults.object(forKey: "Name") != nil) && (defaults.object(forKey: "URL") != nil) {
            defaults.removeObject(forKey: "Name")
            defaults.removeObject(forKey: "URL")
        }
        
        if (defaults.object(forKey: "channelNames") != nil) && (defaults.object(forKey: "channelURLs") != nil) {
            defaults.removeObject(forKey: "channelNames")
            defaults.removeObject(forKey: "channelURLs")
        }
        
        if (defaults.object(forKey: "Names") != nil) && (defaults.object(forKey: "URLs") != nil) {
            defaults.removeObject(forKey: "Name")
            defaults.removeObject(forKey: "URL")
        }
        
        if (defaults.object(forKey: "Names v.103") != nil) {       // object name is not empty
            channelNames = defaults.object(forKey: "Names v.103") as? [String] ?? [String]()
            channelURLs = defaults.object(forKey: "URLs v.103") as? [String] ?? [String]()
        }

        addGradientBackground()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ChannelTableViewController.longPressGestureRecognized(_:)))
        longpress.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longpress)
    }
    
    func addGradientBackground() -> () {
        
        let backgroundView = UIView()
        let background = CAGradientLayer().turquoiseColor()
        let deviceScale = UIScreen.main.scale
        background.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width * deviceScale, height: view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
        
    }

    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        var locationInView = longPress.location(in: self.tableView)
        var indexPath = self.tableView.indexPathForRow(at: locationInView)
        
        func snapshopOfCell(_ inputView: UIView) -> UIView {
            UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
            inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            let cellSnapshot : UIView = UIImageView(image: image)
            cellSnapshot.layer.masksToBounds = false
            cellSnapshot.layer.cornerRadius = 0.0
            cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
            cellSnapshot.layer.shadowRadius = 5.0
            cellSnapshot.layer.shadowOpacity = 0.4
            return cellSnapshot
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = self.tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot = snapshopOfCell(cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                self.tableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell?.isHidden = true
                        }
                })
            }
            
        case UIGestureRecognizerState.changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                
                swap(&channelNames[indexPath!.row], &channelNames[Path.initialIndexPath!.row])
                swap(&channelURLs[indexPath!.row], &channelURLs[Path.initialIndexPath!.row])
                
                defaults.set(channelNames, forKey: "Names v.103")
                defaults.set(channelURLs, forKey: "URLs v.103")
                
                tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
            
            
        default:
            let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = (cell?.center)!
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell?.alpha = 1.0
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = channelNames[(indexPath as NSIndexPath).row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChannel" {
            let tvc: TableViewController = segue.destination as! TableViewController
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            tvc.channelName = channelNames[(indexPath as NSIndexPath).row]
            tvc.channelURL = channelURLs[(indexPath as NSIndexPath).row]
            tvc.channelRow = (indexPath as NSIndexPath).row
        }
    }
}
