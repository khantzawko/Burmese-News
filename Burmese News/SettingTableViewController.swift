//
//  SettingTableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 6/10/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Setting View")

        let builder: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker?.send(builder as! [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addGradientBackground() -> () {
        let backgroundView = UIView()
        let background = CAGradientLayer().turquoiseColor()
        let deviceScale = UIScreen.main.scale
        background.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width * deviceScale, height: view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
    }}
