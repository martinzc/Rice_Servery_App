//
//  FirstViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 6/5/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var menuView: BTNavigationDropdownMenu!
    var menu = []
    var selectedServery = ""
    var menu_dict = [String: [String]]()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl.addTarget(self, action: #selector(FirstViewController.uiRefreshControlAction), forControlEvents: .ValueChanged)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.tableView.addSubview(refreshControl)
        
        self.menu_dict = connectAndParse()
        
        // creating an Array that contains strings as elements of dropdown list
        let servery = ["South", "SidRich", "West", "Baker", "Seibel", "North"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: servery[0], items: servery)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        
        
        self.selectedServery = servery[0]
        self.menu = menu_dict[self.selectedServery]!
        self.tableView.reloadData()
        
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            // Change table cell item in this section
            self.selectedServery = servery[indexPath]
            self.menu = self.menu_dict[self.selectedServery]!
            self.tableView.reloadData()
        }
        
        self.navigationItem.titleView = menuView
        
        
    }
    
    func uiRefreshControlAction() {
        self.menu_dict = connectAndParse()
        self.menu = menu_dict[self.selectedServery]!
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.menu[indexPath.row] as? String
        return cell
    }


}

