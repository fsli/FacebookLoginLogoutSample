//
//  ViewController.swift
//  FacebookLoginLogoutSample
//
//  Created by Ferris Li on 3/17/16.
//  Copyright © 2016 Ferris Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, FBSDKSharingDelegate {

    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    let facebookWritePermissions = ["publish_actions"]
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
        
        /*loginManager.logInWithReadPermissions(facebookReadPermissions, fromViewController: self) { (result, error) -> Void in
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
        }*/
        loginManager.logInWithPublishPermissions(facebookWritePermissions, fromViewController: self) { (result, error) -> Void in
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
        loginManager.logOut()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print(FBSDKAccessToken.currentAccessToken().tokenString)
        } else {
            print("nil access token")
            self.customLoginButton.hidden = false
        }
    }
    
    @IBAction func onShareButonTouched(sender: AnyObject) {
        let content = FBSDKShareLinkContent()
        //sharing a random URL page content so that it won't be blocked by facebook on iphone.
        content.contentURL = NSURL(string:"http://google.com/?q=\(NSDate().timeIntervalSince1970 * 1000)")
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
        
    }
    
    @available(iOS 2.0, *)
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if (results["postId"] != nil) {
            print("shared")
            let alertController = UIAlertController(title: "FerrisDemoApp", message:
            "Message has been posted to Facebook!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            print("canceled")
        }
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alertController = UIAlertController(title: "FerrisDemoApp", message:
            "Failed to post message to Facebook!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
}

