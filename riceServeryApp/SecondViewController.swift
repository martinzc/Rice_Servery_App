//
//  SecondViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 6/5/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        if ((GIDSignIn.sharedInstance().currentUser) != nil) {
            add(asChildViewController: featureViewController)
        } else {
            add(asChildViewController: signInViewController)
        }
    }
    
    private lazy var featureViewController: FeaturedViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewControllerWithIdentifier("FeaturePage") as! FeaturedViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var signInViewController: SignInViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewControllerWithIdentifier("SignInPage") as! SignInViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // Notify Child View Controller
        viewController.didMoveToParentViewController(self)
    }
    
}

