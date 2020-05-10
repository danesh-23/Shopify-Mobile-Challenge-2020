//
//  IAPViewController.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-03-20.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class IAPViewController: UIViewController {

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var getiapbuttonView: UIButton!
    @IBOutlet weak var restorePurchasesLabel: UIButton!
    
    @IBAction func restorePurchase(_ sender: Any) {
        IAPHandler.shared.restorePurchase()
        let restoredPurchasesBool = UserDefaults.standard.object(forKey: "restoredPurchasesBool")
        DispatchQueue.main.async {
            if restoredPurchasesBool as? Bool == true  {
                let restoredMessage = UIAlertController(title: NSLocalizedString("Restore Purchases :)", comment: ""), message: NSLocalizedString("You have purchased the PaperSaver feature using this apple ID before, so the in app purchase is restored and you may use it as normal.\n You may contact us using the Message button in the previous page for any problems. Enjoy!", comment: ""), preferredStyle: .alert)
                restoredMessage.addAction(UIAlertAction(title: NSLocalizedString("Learn how to use PaperSaver.", comment: "") , style: UIAlertAction.Style.destructive, handler: { action in self.dismiss(animated: true, completion: nil)}))
                self.present(restoredMessage, animated: true, completion: nil)
            } else {
                let restoredMessage = UIAlertController(title: NSLocalizedString("Restore Purchases Unavailable", comment: ""), message: NSLocalizedString("The Restore Purchases button has to be clicked again to restore the feature if you have previously purchased this feature using the same Apple ID. If you have not already purchased the PaperSaver in-app feature before, you are unable to restore this purchase and must click 'Get A+ Now :)' button to get it.", comment: ""), preferredStyle: .alert)
                restoredMessage.addAction(UIAlertAction(title: NSLocalizedString("Get PaperSaver Now!", comment: "") , style: UIAlertAction.Style.destructive, handler: nil))
                self.present(restoredMessage, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = NSLocalizedString("PaperSaver: Download Feature", comment: "")
        textView.text = NSLocalizedString("Why people were demanding for this feature:\n\n• Allows users to download and save any papers.\n\n• Makes revising possible ANYWHERE!\n\n• Eradicates the need for an internet connection once papers are downloaded.\n\n• Users can prepare for being offline by a few simple clicks to have any paper downloaded, rather than screenshotting every single page of the papers.\n\nALL of these features provided for the second lowest possible price on the App Store and under $2; an easily affordable $1.99 USD.\n\nClick below to get a bargain of a lifetime.\n\nSwipe down to close.", comment: "")
        getiapbuttonView.setTitle(NSLocalizedString("GET A+ NOW :)", comment: ""), for: .normal)
        restorePurchasesLabel.setTitle(NSLocalizedString("Restore Purchases :)", comment: ""), for: .normal)
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeToClose(sender:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeToClose(sender: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getIAP(_ sender: Any) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }
}
