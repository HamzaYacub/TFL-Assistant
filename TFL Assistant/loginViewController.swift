//
//  loginViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 11/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI


class loginViewController: UIViewController {
    
    @IBOutlet weak var anon: UIButton!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            print("Current user: \(String(describing: Auth.auth().currentUser))")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                self.performSegue(withIdentifier: "goHome", sender: self)
            }
        
        }

    }
    

    @IBAction func loginTouched(_ sender: UIButton) {
        
        if sender.tag == 1 {
            //Get the default auth UI object
            
            let authUI = FUIAuth.defaultAuthUI()
            
            guard authUI != nil else{
                //Log the error
                return
            }
            
            
            //Set ourselves as the delegate
            
            authUI?.delegate = self
            authUI?.providers = [FUIEmailAuth()]
            
            
            //Get a reference to the auth UI view controller
            let authViewController = authUI!.authViewController()
            
            //Show it
            
            present(authViewController, animated: true, completion: nil)
        
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            
            guard authUI != nil else{
                //Log the error
                return
            }
            
            authUI?.delegate = self
            authUI?.providers = [FUIAnonymousAuth()]
            
            
            Auth.auth().signInAnonymously { (user, error) in
                
                
                if let error = error {
                    print("Sign in failed:", error.localizedDescription)
                    
                } else {
                    print ("Signed in with uid:", user ?? "")
                    self.performSegue(withIdentifier: "goHome", sender: self)
                }

            }

        }
        
        
        
    }
    
  
  
    
}


extension loginViewController: FUIAuthDelegate{
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //check if there was error
        if error != nil {
            //Log the error
            return
        }
        
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "goHome", sender: self)
        
        
    }
    
}
