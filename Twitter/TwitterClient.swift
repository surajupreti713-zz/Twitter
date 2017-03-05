//
//  TwitterClient.swift
//  Twitter
//
//  Created by Suraj Upreti on 3/5/17.
//  Copyright © 2017 Suraj Upreti. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "ZaVMaIwP0L2NHNuukpuGCK27j", consumerSecret: "147HztnlTzfvXffsVx35TqR2FVWVMlxC6CoMem2hL7fIIHdMCP")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping() -> (), failure: @escaping(NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        let client = TwitterClient.sharedInstance
        client?.deauthorize()
        client?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error )
            })
            
            
        }, failure: { (error: Error?) in
            print(error?.localizedDescription)
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
         get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            //print("account: \(response)")
            let dictionaries = response as? [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries!)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error as NSError)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping(NSError) -> ()) {
        get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error as NSError)
        })
    }
    
}
