//
//  ViewController.swift
//  FacebookLoginLogoutSample
//
//  Created by Ferris Li on 3/17/16.
//  Copyright © 2016 Ferris Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton:FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.readPermissions = facebookReadPermissions
        loginButton.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBOutlet weak var customLoginButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginByLoginManager(sender: AnyObject) {
        loginManager.loginBehavior = FBSDKLoginBehavior.Web
        
        loginManager.logInWithReadPermissions(facebookReadPermissions, fromViewController: self) { (result, error) -> Void in
            if (error != nil) {
                print(error)
            } else if (result.isCancelled) {
                print("login canceled")
            } else {
                print("login successfully!")
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    print("Access token : " + FBSDKAccessToken.currentAccessToken().tokenString)
                    self.customLoginButton.hidden = true
                    
                }
            }
        }

    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error == nil)
        {
            print("login complete. Access token:")
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                print("Access token: " + FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
        else{
            print(error.localizedDescription)
        }

    }
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("login button did logout")
        //loginManager.logOut()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print(FBSDKAccessToken.currentAccessToken().tokenString)
        } else {
            print("nil access token")
            self.customLoginButton.hidden = false
        }
    }
}

