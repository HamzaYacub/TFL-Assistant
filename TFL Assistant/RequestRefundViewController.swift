//
//  RequestRefundViewController.swift
//  
//
//  Created by Hamza Yacub on 22/04/2019.
//

import UIKit
import MessageUI

class RequestRefundViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var message: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HideKeyboard()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendEmail(_ sender: Any) {
        
        let mailComposeViewController = configureMailController()
        
        if message.text == "" {
            let alert = UIAlertController(title: "Error! No message written.",
                                          message: "Please check that you have written a message.",
                                          preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        
        } else if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        
        } else {
            let sendMailErrorAlert = UIAlertController(title: "Error! Could not send Email.",
                                                       message: "Your device could not send the email.",
                                                       preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            sendMailErrorAlert.addAction(UIAlertAction(title: "Okay",
                                                       style: UIAlertAction.Style.default,
                                                       handler: nil))
            // show the alert
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        
        
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        mailComposeVC.setToRecipients(["w1589585@my.westminster.ac.uk"])
        mailComposeVC.setSubject("Refund Request")
        mailComposeVC.setMessageBody(message.text, isHTML: false)
        
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        message.text = ""
        
    }
    

}
