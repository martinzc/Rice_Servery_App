//
//  FirstViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 6/5/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import CoreLocation

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var selectedRow: Int?
    @IBOutlet weak var tableView: UITableView!
    var menuView: BTNavigationDropdownMenu!
    var menu: [String] = []
    var selectedServery = ""
    var menu_dict = [String: [String]]()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    // creating an Array that contains strings as elements of dropdown list
    var servery = ["South", "SidRich", "West", "Baker", "Seibel", "North"]
    let serveryLocation : [String: (Double, Double)] = [
        "South": (29.715499, -95.400982),
         "SidRich": (29.715081, -95.399081),
         "West": (29.720525, -95.397758),
         "Baker": (29.716993, -95.399681),
         "Seibel": (29.716007, -95.398400),
         "North": (29.721510, -95.396806)
    ]
    
    private let strKey = "favDishes"
    private let memory = NSUbiquitousKeyValueStore()
    var favDishes: [String] {
        get {
            if let returnVal = memory.objectForKey(strKey) as? [String] {
                return returnVal
            } else {
                return []
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up location manager
        setUpLocationManager()
        
        refreshControl.addTarget(self, action: #selector(FirstViewController.uiRefreshControlAction), forControlEvents: .ValueChanged)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.tableView.addSubview(refreshControl)
        
        self.menu_dict = connectAndParse()
        
        buildTabBar()
        
        notify()
        
    }
    
    func buildTabBar() {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: servery[0], items: servery)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        
        self.selectedServery = servery[0]
        self.menu = menu_dict[self.selectedServery]!
        if (self.menu.count == 0) {
            self.menu = ["Not open for this meal"]
        }
        self.tableView.reloadData()
        
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            // Change table cell item in this section
            self.selectedServery = self.servery[indexPath]
            self.menu = self.menu_dict[self.selectedServery]!
            if (self.menu.count == 0) {
                self.menu = ["Not open for this meal"]
            }
            self.tableView.reloadData()
        }
        
        self.navigationItem.titleView = menuView
    }
    
    func notify() {
        var fav_dict = [String: [String]]()
        for (individualServery, serveryMenu) in menu_dict {
            fav_dict[individualServery] = []
            for dish in serveryMenu {
                for individualFavDish in favDishes {
                    if dish.rangeOfString(individualFavDish) != nil {
                        fav_dict[individualServery]!.append(dish)
                        break;
                    }
                }
            }
        }
        var bestServery = ""
        var mostDishes = []
        for (individualServery, serveryMenu) in fav_dict {
            if serveryMenu.count >= mostDishes.count {
                bestServery = individualServery
                mostDishes = serveryMenu
            }
        }
        let alertController = UIAlertController(title: "Recommend " + bestServery, message:
            "Dishes you would like: " +
                mostDishes.componentsJoinedByString(", "), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setUpLocationManager() {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Authorization granted")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func distance(serveryName: String, coordinate: CLLocationCoordinate2D) -> Double {
        return pow(coordinate.latitude.distanceTo((serveryLocation[serveryName]?.0)!), 2) + pow(coordinate.longitude.distanceTo((serveryLocation[serveryName]?.1)!), 2)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        servery.sortInPlace({ distance($0, coordinate: locValue) < distance($1, coordinate: locValue) })
        buildTabBar()
        print(locValue)
        manager.stopUpdatingLocation()
    }
    
    func uiRefreshControlAction() {
        self.menu_dict = connectAndParse()
        self.menu = menu_dict[self.selectedServery]!
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.menu[indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier("menuDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuDetailSegue" {
            let destination = segue.destinationViewController as! MenuDetailViewController
            //            , let indexPath = tableView.indexPathForCell(cell)
            destination.inDish = self.menu[selectedRow!] as String
        }
    }
    


}

