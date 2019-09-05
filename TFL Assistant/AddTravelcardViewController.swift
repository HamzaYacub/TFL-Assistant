//
//  TravelcardViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 20/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import Firebase

class AddTravelcardViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var travelcardsList: UIPickerView!
    @IBOutlet weak var oystercardsList: UIPickerView!
    @IBOutlet weak var activeOyster: UILabel!
    @IBOutlet weak var chosenTravelcard: UILabel!
    @IBOutlet weak var travelcardPrice: UILabel!
    @IBOutlet weak var date: UIPickerView!
    @IBOutlet weak var dateTravelcardMonth: UILabel!
    @IBOutlet weak var dateTravelcardDay: UILabel!
    @IBOutlet weak var proceed: UIButton!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet var popOver: UIView!
    @IBOutlet weak var card_digit: UITextField!
    @IBOutlet weak var card_expiryMM: UITextField!
    @IBOutlet weak var card_expiryYY: UITextField!
    @IBOutlet weak var card_cvc: UITextField!
    
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var cardArray = [String]()
    
    var travelcardArray = ["Weekly - Zone 1", "Weekly - Zones 1-2", "Weekly - Zones 1-3",
                           "Weekly - Zones 1-4", "Weekly - Zones 1-5", "Weekly - Zones 1-6",
                           "Weekly - Zones 1-7", "Weekly - Zones 1-8", "Weekly - Zones 1-9",
                           "Monthly - Zone 1", "Monthly - Zones 1-2", "Monthly - Zones 1-3",
                           "Monthly - Zones 1-4", "Monthly - Zones 1-5", "Monthly - Zones 1-6",
                           "Monthly - Zones 1-7", "Monthly - Zones 1-8", "Monthly - Zones 1-9"]
    
    var months = ["January", "February", "March", "April",
                  "May", "June", "July", "August",
                  "September", "October", "November", "December"]
    
    var days = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    let UserID = Auth.auth().currentUser!.uid
    

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
        
        
        //read data from firebase
        
        ref = Database.database().reference()
        
        ref?.child("users").child("\(UserID)").child("oystercards").observe(.childAdded, with: { (snapshot) in
            
            
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
        } else {
            return false
        }
        
    }
    
    @IBAction func popUpPayment(_ sender: Any) {
        
        if (chosenTravelcard.text == "") || (activeOyster.text == "None") || (travelcardPrice.text == "0.00") || (dateTravelcardMonth.text == "") || (dateTravelcardDay.text == "") {
            let alert = UIAlertController(title: "Error! Missing fields.",
                                          message: "Please check that you have selected a travelcard for an oystercard and chosen a date.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "February") &&  (dateTravelcardDay.text == "30" || dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "April") &&  (dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "June") &&  (dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "August") &&  (dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "October") &&  (dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (dateTravelcardMonth.text == "December") &&  (dateTravelcardDay.text == "31") {
            
            let alert = UIAlertController(title: "Error! This date does not exist.", message: "Please ensure that you have selected the correct date.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.view.addSubview(popOver)
            payment.text = travelcardPrice.text
            proceed.isEnabled = false
        }
        

        
    }
    
    @IBAction func confirm(_ sender: Any) {
        
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
                .setValue(travelcardPrice.text)
            
            
            //save travelcard into database depending on oyster chosen
            
            let length = String(dateTravelcardMonth.text! + " " + dateTravelcardDay.text!)
            
            ref?.child("users")
                .child("\(UserID)")
                .child("travelcards")
                .child(activeOyster.text!)
                .setValue(["startingDate" : length, "travelcard_type" : chosenTravelcard.text])
            
            
            let alert = UIAlertController(title: "Payment Successful!",
                                          message: "Your travelcard will activate on your chosen date.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            

    }
}
        
    
    @IBAction func cancel(_ sender: Any) {
        
        self.popOver.removeFromSuperview()
        proceed.isEnabled = true
    }
    

}

extension AddTravelcardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        if (pickerView == oystercardsList) || (pickerView == travelcardsList) {
            return 1
        } else {
            return 2
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == oystercardsList {
            return cardArray.count
        } else if pickerView == travelcardsList {
            return travelcardArray.count
        } else {
            
            if component == 0{
                return months.count
            } else {
                return days.count
            }
  
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == oystercardsList {
            
            if cardArray.count > 0{
                activeOyster.text = cardArray[row]
            } else {
                activeOyster.text = "None"
            }
            
            
        } else if pickerView == travelcardsList {
            
            chosenTravelcard.text = travelcardArray[row]
            
            if travelcardArray[row] == "Weekly - Zone 1"{
                travelcardPrice.text = "35.10"
            } else if travelcardArray[row] == "Weekly - Zones 1-2"{
                travelcardPrice.text = "35.10"
            } else if travelcardArray[row] == "Weekly - Zones 1-3"{
                travelcardPrice.text = "41.20"
            } else if travelcardArray[row] == "Weekly - Zones 1-4"{
                travelcardPrice.text = "50.50"
            } else if travelcardArray[row] == "Weekly - Zones 1-5"{
                travelcardPrice.text = "60.00"
            } else if travelcardArray[row] == "Weekly - Zones 1-6"{
                travelcardPrice.text = "64.20"
            } else if travelcardArray[row] == "Weekly - Zones 1-7"{
                travelcardPrice.text = "69.80"
            } else if travelcardArray[row] == "Weekly - Zones 1-8"{
                travelcardPrice.text = "82.50"
            } else if travelcardArray[row] == "Weekly - Zones 1-9"{
                travelcardPrice.text = "91.50"
            } else if travelcardArray[row] == "Monthly - Zone 1"{
                travelcardPrice.text = "134.80"
            } else if travelcardArray[row] == "Monthly - Zones 1-2"{
                travelcardPrice.text = "134.80"
            } else if travelcardArray[row] == "Monthly - Zones 1-3"{
                travelcardPrice.text = "158.30"
            } else if travelcardArray[row] == "Monthly - Zones 1-4"{
                travelcardPrice.text = "194.00"
            } else if travelcardArray[row] == "Monthly - Zones 1-5"{
                travelcardPrice.text = "230.40"
            } else if travelcardArray[row] == "Monthly - Zones 1-6"{
                travelcardPrice.text = "246.60"
            } else if travelcardArray[row] == "Monthly - Zones 1-7"{
                travelcardPrice.text = "268.10"
            } else if travelcardArray[row] == "Monthly - Zones 1-8"{
                travelcardPrice.text = "316.80"
            } else if travelcardArray[row] == "Monthly - Zones 1-9"{
                travelcardPrice.text = "351.40"
            }
        } else if pickerView == date{
            
            var chosenMonth = String()
            var chosenDay = String()
            
            if component == 0 {
                chosenMonth = months[row]
                dateTravelcardMonth.text = chosenMonth
                
            } else {
                chosenDay = days[row]
                dateTravelcardDay.text = chosenDay
                
            }
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == oystercardsList {
            return cardArray[row]
        } else if pickerView == travelcardsList{
            return travelcardArray[row]
        } else {
            if component == 0 {
                return months[row]
            } else {
                return days[row]
            }
        }
 
    }
    
}
