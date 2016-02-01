//
//  SettingTableViewController.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 6/10/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
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
        let deviceScale = UIScreen.mainScreen().scale
        background.frame = CGRectMake(0.0, 0.0, view.frame.size.width * deviceScale, view.frame.size.height * deviceScale)
        backgroundView.layer.insertSublayer(background, above: nil)
        self.tableView.backgroundView = backgroundView
        
    }}
