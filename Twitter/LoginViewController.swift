//
//  LoginViewController.swift
//  Twitter
//
//  Created by Suraj Upreti on 3/4/17.
//  Copyright © 2017 Suraj Upreti. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func onLoginButton(_ sender: Any) {
        let client = TwitterClient.sharedInstance
        client?.login(success: {() -> () in
            print("logged in successfully")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
             
        }, failure: { (error: NSError) in
            print("error: \(error.localizedDescription)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
