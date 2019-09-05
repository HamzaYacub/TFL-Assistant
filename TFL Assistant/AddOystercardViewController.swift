//
//  AddOystercardViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 19/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddOystercardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addCard: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    
    var ref:DatabaseReference?

    let UserID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HideKeyboard()
        
        numberTF.delegate = self
        
        ref = Database.database().reference()
    }
    
    @IBAction func addNewOyster(_ sender: Any) {
        
        if (nameTF.text == "") || (numberTF.text == "") {
            let alert = UIAlertController(title: "Error! Missing Fields.", message: "Please ensure that the name and number of your oystercard have been filled out.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            ref?.child("users").child("\(UserID)").child("oystercards").childByAutoId().setValue(nameTF.text)
            
            let alert = UIAlertController(title: "New User Added", message: "Successfully added new user into database.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            nameTF.text = ""
            numberTF.text = ""
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        
        if textField == numberTF {
            return newLength <= 12
        } else {
            return false
        }
        
    }
    
}
