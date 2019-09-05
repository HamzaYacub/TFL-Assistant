//
//  AddFundsViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 19/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class AddFundsViewController: UIViewController, UITextFieldDelegate{


    @IBOutlet weak var oystercardsList: UIPickerView!
    @IBOutlet weak var activeOyster: UILabel!
    @IBOutlet weak var totalPay: UILabel!
    @IBOutlet weak var payTF: UITextField!
    @IBOutlet var popOver: UIView!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var popoverpaylabel: UILabel!
    @IBOutlet weak var proceed: UIButton!
    @IBOutlet weak var card_digit: UITextField!
    @IBOutlet weak var card_expiryMM: UITextField!
    @IBOutlet weak var card_expiryYY: UITextField!
    @IBOutlet weak var card_cvc: UITextField!
    
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?

    var cardArray = [String]()
    
    let UserID = Auth.auth().currentUser!.uid
    
    var amount: Int = 0
    var activeFunds = String()
    var newFundString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popOver.layer.cornerRadius = 10
        self.popOver.frame.origin.y = 125
        self.popOver.frame.origin.x = 100
        
        HideKeyboard()
        
        oystercardsList.dataSource = self
        oystercardsList.delegate = self
        card_digit.delegate = self
        card_expiryMM.delegate = self
        card_expiryYY.delegate = self
        card_cvc.delegate = self
        payTF.delegate = self
        

        ref = Database.database().reference()
        
        ref?.child("users")
            .child("\(UserID)")
            .child("oystercards")
            .observe(.childAdded, with: { (snapshot) in
           
            
            if !snapshot.exists() {
                return
            }
            
            print (snapshot)
            
                let oyster = snapshot.value as? String

                if let actualOyster = oyster {

                    self.cardArray.append(actualOyster)

                }
            
                print (self.cardArray)
            
            
            //Reload the pickerview
            self.oystercardsList.reloadAllComponents()

        })

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length

        
        if textField == card_digit {
            return newLength <= 16
        } else if textField == card_expiryMM {
            return newLength <= 2
        } else if textField == card_expiryYY {
            return newLength <= 2
        } else if textField == card_cvc {
            return newLength <= 4
        } else if textField == payTF {
            return newLength <= 4
        } else {
            return false
        }
 
    }
    
    @IBAction func pay(_ sender: UITextField) {
        
        if payTF.text == ""  {
            totalPay.text = "0.00"
        } else {
            totalPay.text = payTF.text! + ".00"
        }
        

    }
    
    
    @IBAction func popUpPayment(_ sender: UIButton) {
        
        if (totalPay.text == "0.00") || (activeOyster.text == "None") {
            let alert = UIAlertController(title: "Error! Missing fields.",
                                          message: "Please check that you have chosen an oystercard and added some funds.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            self.view.addSubview(popOver)
            popoverpaylabel.text = totalPay.text
            proceed.isEnabled = false
        }
        
        ref?.child("users")
            .child("\(UserID)")
            .child("funds")
            .child(activeOyster.text!)
            .child("amount")
            .observe(.value, with: { (snapshot) in
                
                if !snapshot.exists() {
                    print("nothing here")
                }
                
                print (snapshot)
                
                
                let oyster = snapshot.value as? String
                
                
                if let actualOyster = oyster {
                    
                    self.activeFunds = actualOyster
                    
                }
            })
        
        
        
    }
    
    @IBAction func cancelPayment(_ sender: UIButton) {
        
        self.popOver.removeFromSuperview()
        proceed.isEnabled = true
    }
    
    @IBAction func confirmPayment(_ sender: Any) {
        
        if (card_digit.text == "") || (card_expiryMM.text == "") || (card_expiryYY.text == "") || (card_cvc.text == "") {
            let alert = UIAlertController(title: "Error! Missing fields.",
                                          message: "Please check that you have entered in all the fields.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if (card_expiryMM.text != "01") && (card_expiryMM.text != "02") && (card_expiryMM.text != "03") && (card_expiryMM.text != "04") && (card_expiryMM.text != "05") && (card_expiryMM.text != "06") && (card_expiryMM.text != "07") && (card_expiryMM.text != "08") && (card_expiryMM.text != "09") && (card_expiryMM.text != "10") && (card_expiryMM.text != "11") && ( card_expiryMM.text != "12") {
            
            let alert = UIAlertController(title: "Error! Invalid Month entered.",
                                          message: "Please check that you have entered the correct month in MM format.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.popOver.removeFromSuperview()
            proceed.isEnabled = true
            
            //save payment into database
            
            ref?.child("users")
                .child("\(UserID)")
                .child("payments")
                .childByAutoId()
                .setValue(popoverpaylabel.text)
            
            
            //fund calculation
            
            let oldFund = Double(activeFunds)
            let addFund = Double(popoverpaylabel.text!)
            
            if oldFund == nil {
                newFundString = popoverpaylabel.text!
            } else {
                let newFund = Double(oldFund! + addFund!)
                newFundString = String(newFund)
            }

            
            //save funds into database depending on oyster chosen
            
            
            
            ref?.child("users")
                .child("\(UserID)")
                .child("funds")
                .child(activeOyster.text!)
                .child("amount")
                .setValue(newFundString)
            
            print(activeFunds)
            
            
            
            let alert = UIAlertController(title: "Payment Successful!",
                                          message: "Your funds have been added.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            payTF.text = ""
            totalPay.text = "0.00"
        }

    }

}

extension AddFundsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if cardArray.count > 0{
            activeOyster.text = cardArray[row]
        } else {
            activeOyster.text = "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cardArray[row]
    }
    
}
