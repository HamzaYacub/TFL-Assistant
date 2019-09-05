//
//  ViewOystercardViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 21/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit
import Firebase
import CoreNFC

class ViewOystercardViewController: UIViewController, NFCNDEFReaderSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeOyster: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var oystercards: UITableView!
    @IBOutlet var popOver: UIView!
    @IBOutlet weak var activeOysterSubView: UILabel!
    @IBOutlet var historyPopOver: UIView!
    @IBOutlet weak var activeTravelcard: UILabel!
    @IBOutlet weak var activeFunds: UILabel!
    @IBOutlet weak var history: UITableView!
    
    
    var nfcSession : NFCNDEFReaderSession?
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
   
    
    //reuse of cells that scroll out of the view
    let cellReuseIdentifier = "myCell"
    
    var fundString = [String]()
    var travelcardString = String()
    var oldfundString = String("0.0")
    var newFund = Double()
    var newFundString = String()
    var cardArray = [String]()
    var historyArray = [String]()
    var cardKey = [String]()
    
    let UserID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.popOver.layer.cornerRadius = 10
        self.popOver.frame.origin.y = 70
        self.popOver.frame.origin.x = 18
        
        self.historyPopOver.layer.cornerRadius = 10
        self.historyPopOver.frame.origin.y = 90
        self.historyPopOver.frame.origin.x = 50
        
        oystercards.delegate = self
        oystercards.dataSource = self
        
        oystercards.allowsMultipleSelectionDuringEditing = true
        
        history.delegate = self
        history.dataSource = self

        // Register the table view cell class and its reuse id
        self.oystercards.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        // Register the table view cell class and its reuse id
        self.history.register(UITableViewCell.self, forCellReuseIdentifier: "mySecondCell")

        //read data from firebase
        
        ref = Database.database().reference()
        
        ref?.child("users").child("\(UserID)").child("oystercards").observe(.childAdded, with: { (snapshot) in
            
            
            if !snapshot.exists() {
                return
            }
            
            print (snapshot)
            
            
            let oysterKey = snapshot.key as? String
            
            if let actualOysterKey = oysterKey {
                
                self.cardKey.append(actualOysterKey)
                
            }
            
            print(self.cardKey)
            
            
            
            let oyster = snapshot.value as? String
            
            if let actualOyster = oyster {
                
                self.cardArray.append(actualOyster)
                
            }
            
            print (self.cardArray)
            
            //reload data into tableview
            self.oystercards.reloadData()
            
        })
        
        
        
        

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView == oystercards {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        ref?.child("users").child("\(UserID)").child("oystercards").child(cardKey[indexPath.row]).removeValue(completionBlock: { (error, ref) in
                
            if error != nil {
                print("Failed to delete message: ", error!)
                return
                    
            }

            self.cardArray.remove(at: indexPath.row)
            self.oystercards.deleteRows(at: [indexPath], with: .automatic)
                
                
        })
        

        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == oystercards {
            return cardArray.count
        } else {
            return historyArray.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == oystercards {
            
            // create a new cell if needed or reuse an old one
            let cell:UITableViewCell = oystercards.dequeueReusableCell(withIdentifier: "myCell") as UITableViewCell!
            
            // set the text from the data model
            cell.textLabel?.text = self.cardArray[indexPath.row]
            
            return cell
        } else {
            // create a new cell if needed or reuse an old one
            let cell:UITableViewCell = history.dequeueReusableCell(withIdentifier: "mySecondCell") as UITableViewCell!
            
            // set the text from the data model
            cell.textLabel?.text = self.historyArray[indexPath.row]
            
            return cell
        }
        
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == oystercards {
            
        
        print("You tapped cell number \(indexPath.row).")
        
        self.view.addSubview(popOver)
        activeOysterSubView.text! = cardArray[indexPath.row]
        
        
        ref?.child("users")
            .child("\(UserID)")
            .child("funds")
            .child(activeOysterSubView.text!)
            .child("amount")
            .observe(.value, with: { (snapshot) in
                
                if !snapshot.exists() {
                    print("nothing here")
                }
                
                print (snapshot)
                
                let oyster = snapshot.value as? String
                
                if oyster == nil {
                    self.activeFunds.text! = "0.00"
                } else {
                    if let actualOyster = oyster {
                        
                        self.activeFunds.text! = actualOyster
                        
                    }
                }

            })
        
        ref?.child("users")
            .child("\(UserID)")
            .child("travelcards")
            .child(activeOysterSubView.text!)
            .child("travelcard_type")
            .observe(.value, with: { (snapshot) in
                
                if !snapshot.exists() {
                    print("nothing here")
                }
                
                print (snapshot)
                
                
                let oyster = snapshot.value as? String
                
                if oyster == nil {
                    self.activeTravelcard.text! = "None"
                } else {
                    if let actualOyster = oyster {
                        
                        self.activeTravelcard.text! = actualOyster
                        
                    }
                }
                
                
            })
            self.historyArray.removeAll()

        } else {
            return
        }
    
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.popOver.removeFromSuperview()
        self.historyPopOver.removeFromSuperview()
        self.historyArray.removeAll()
        
    }
    
    @IBAction func activation(_ sender: Any) {
        
        if (activeTravelcard.text == "None") && (activeFunds.text == "0.00") {
            let alert = UIAlertController(title: "Activation Declined!",
                                          message: "You don't have any funds or a travelcard.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            self.popOver.removeFromSuperview()
            
            let alert = UIAlertController(title: "Activation Successful!",
                                          message: "Your card is now active.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            activeOyster.text = activeOysterSubView.text
        }
        
    }
    
    
    @IBAction func checkHistory(_ sender: Any) {
        
        self.view.addSubview(historyPopOver)
        self.history.reloadData()
        
        
        ref?.child("users")
            .child("\(UserID)")
            .child("oyster_history")
            .child(activeOysterSubView.text!)
            .observe(.childAdded, with: { (snapshot) in
                
                
                if !snapshot.exists() {
                    return
                }
                
                print (snapshot)
                
                let oyster = snapshot.value as? String
                
                
                if let actualOyster = oyster {
                    self.historyArray.append(actualOyster)
                }
                
                if self.historyArray.isEmpty {
                    self.historyArray.append("No Journies made")
                }
                
                
                print (self.historyArray)
                
                //reload data into tableview
                self.history.reloadData()
                
            })
        
    }
    
    
    @IBAction func cancelHistoryView(_ sender: Any) {
        
        self.historyArray.removeAll()
        self.historyPopOver.removeFromSuperview()
        self.view.addSubview(popOver)
        
    }
    
    
    
    @IBAction func scanOyster(_ sender: Any) {
        
        if activeOyster.text == "None" {
            let alert = UIAlertController(title: "No Oystercard Active!",
                                          message: "Please activate an oystercard from the list above.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        
        } else if (activeTravelcard.text == "None") && (activeFunds.text == "0.00") {
    
                let alert = UIAlertController(title: "No Funds Available!",
                                              message: "Please add some funds or a travelcard into your oystercard.",
                                              preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            
        } else {
            
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

                        self.oldfundString = actualOyster

                    }



                })
            
            
            nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            let alertMessage = String ("Hold iPhone near the Oystercard Reader")
            nfcSession?.alertMessage = alertMessage
            nfcSession?.begin()
        }

    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    print(string)
                    
                    //fund calculation
                    
                    let oldFund = Double(oldfundString)!
                    let addFund = Double(5.0)
                    
                    if oldFund == 0.0 {
                        newFund = -5.0
                    } else if oldFund <= 0.0 {
                        newFund = 0
                    } else {
                        newFund = Double(oldFund - addFund)
                    }
                        
                    newFundString = String(newFund)
                    
                    //save funds into database depending on oyster chosen
                    
                    if activeTravelcard.text! == "None" {
                        ref?.child("users")
                            .child("\(UserID)")
                            .child("funds")
                            .child(activeOyster.text!)
                            .child("amount")
                            .setValue(newFundString + "0")
                        
                        if newFund <= 0 {
                            let alert = UIAlertController(title: "You have no more funds!",
                                                          message: "Please add more funds into your oystercard.",
                                                          preferredStyle: UIAlertController.Style.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Okay",
                                                          style: UIAlertAction.Style.default,
                                                          handler: nil))
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                    //save history of journey
                    
                    ref?.child("users")
                        .child("\(UserID)")
                        .child("oyster_history")
                        .child(activeOyster.text!)
                        .childByAutoId()
                        .setValue(string)
   
                }
                
            }
            
        }
        
    }

}
