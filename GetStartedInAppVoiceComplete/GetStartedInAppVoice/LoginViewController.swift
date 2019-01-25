//
//  LoginViewController.swift
//  GetStartedInAppVoice
//
//  Created by Paul Ardeleanu on 11/01/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginAsJane(_ sender: Any) {
        loginAs(user: User.jane)
    }
    
    @IBAction func loginAsJoe(_ sender: Any) {
        loginAs(user: User.joe)
    }
    
    func loginAs(user: User) {
        performSegue(withIdentifier: "selectUser", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectUser", let user = sender as? User, let destination = segue.destination as? MainViewController {
            destination.user = user
        }
    }
    
}

