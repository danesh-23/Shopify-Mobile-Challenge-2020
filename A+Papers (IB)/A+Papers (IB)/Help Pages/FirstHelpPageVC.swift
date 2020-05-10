//
//  FirstHelpPageVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-01-19.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit
import MessageUI
import SCLAlertView

let normalFont = UIFont(name: "Futura-Medium", size: 18)
let boldFont = UIFont(name: "Futura-Bold", size: 22)

class FirstHelpPageVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var messageUsText: UIButton!
    @IBOutlet weak var closeHelpText: UIButton!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var paperSaverText: UIButton!
    
    @IBAction func messageUsBtn(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            let alert = SCLAlertView()
            alert.addButton(NSLocalizedString("Set up Mail in Settings", comment: "")) {
                return self.openSettings()
            }
            alert.showInfo(NSLocalizedString("Mail services not set up", comment: ""), subTitle: NSLocalizedString("You need to have mail services set up in Settings to use this feature to send us questions.", comment: ""))
        } else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["apluspapers1208@gmail.com"])
            composeVC.setSubject("App Feedback(IB)")
            composeVC.setMessageBody(NSLocalizedString("(---> \nInsert question/feedback/enquiry here if any :)\n <---)", comment: ""), isHTML: true)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func paperSaverButton(_ sender: Any) {
        self.performSegue(withIdentifier: "seguetogetiap", sender: self)
    }
    
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print(error as Any)
        }
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func closeHelpBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextView.font = normalFont
        featuresLabel.font = normalFont
        titleTextLabel.font = boldFont
        let attributedString = NSMutableAttributedString(string: NSLocalizedString("Help", comment: ""))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        titleTextLabel.attributedText = attributedString
        messageUsText.setTitle("Message Us", for: .normal)
        closeHelpText.setTitle("Close Help", for: .normal)
        mainTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        featuresLabel.text = NSLocalizedString("1. Using PaperSaver - pg 2\n\n2. Using AirPrint - pg 5", comment: "")
        mainTextView.text = NSLocalizedString("Welcome to the Help page.\nYou can find help here regarding the app and how to use it and any current or future features that will be added.\n1. Accessing papers for offline use.\n\nYou may download and save papers for use WITHOUT an internet connection with our latest added in-app feature.\n\nWe present to you, PaperSaver : Your ultimate saviour for accessing and viewing the papers without an internet connection.\n\nPaperSaver allows users the option to download the papers and save them in your iPhone or even on iCloud or Google Drive etc. We have also added a supporting feature which lists the papers downloaded and presents them to you and you can click any to open them up.\n\nFor any further enquiries or suggestions or improvements/complaints about the app, please tap on 'Message' and type your message; click Send, and the A+Papers board will be notified.", comment: "")
    }
}
