//
//  SignInViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 11/10/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signInButton = GIDSignInButton(frame: CGRectMake(0, 0, 100, 50))
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }

}
