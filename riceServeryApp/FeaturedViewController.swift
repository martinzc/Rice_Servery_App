//
//  FeaturedViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 11/10/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let strKey = "favDishes"
    private let memory = NSUbiquitousKeyValueStore()
    var newDish: [String] {
        get {
            if let returnVal = memory.objectForKey(strKey) as? [String] {
                return returnVal
            } else {
                return []
            }
        }
        set {
            memory.setObject(newValue, forKey: strKey)
            memory.synchronize()
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newFav: UITextField!
    
    @IBAction func addNewFavBtn(sender: AnyObject) {
        if ((newFav.text) != nil) {
            newDish.append(newFav.text!)
            newFav.text = nil
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        userName.text = GIDSignIn.sharedInstance().currentUser.profile.email
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My favorite dishes"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newDish.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("favCell", forIndexPath: indexPath)
        cell.textLabel?.text = newDish[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            newDish.removeAtIndex(indexPath.row)
        }
        self.tableView.reloadData()
    }
    
    
}
