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
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "ZaVMaIwP0L2NHNuukpuGCK27j", consumerSecret: "147HztnlTzfvXffsVx35TqR2FVWVMlxC6CoMem2hL7fIIHdMCP")
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
