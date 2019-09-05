//
//  ManageAccountViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 22/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import FirebaseAuth

class ManageAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
        
    }
    
  

}
