//
//  PDFViewController.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-29.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit
import WebKit
import SCLAlertView
import GoogleMobileAds

class PDFViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var airPrintItem: UIBarButtonItem!
    var pdfLink = String()
    @IBOutlet weak var webView: WKWebView!
    var pdfFileName = String()
    var interstitial: GADInterstitial?
    
    @IBAction func airPrintBtn(_ sender: Any) {
        interstitial?.present(fromRootViewController: self)
//        if UIPrintInteractionController.canPrint(URL(string: pdfLink)!) {
//            let printController = UIPrintInteractionController.shared
//
//            let printInfo = UIPrintInfo(dictionary: nil)
//            printInfo.outputType = UIPrintInfo.OutputType.general
//            printInfo.jobName = pdfFileName
//            printController.printInfo = printInfo
//            printController.printingItem = URL(string: pdfLink)
//            printController.present(animated: true, completionHandler: nil)
//        } else {
//            let alertAction = UIAlertController(title: NSLocalizedString("Printer does not support AirPrint", comment: ""), message: NSLocalizedString("This file is unable to print as there are no selected printers that support AirPrint. Please ensure AirPrint is supported although most modern printers have it supported.", comment: ""), preferredStyle: .alert)
//            alertAction.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .destructive, handler: nil))
//            self.present(alertAction, animated: true, completion: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        if let url = URL(string: pdfLink) {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if interstitial != nil {
//            if interstitial!.isReady {
//                interstitial?.present(fromRootViewController: self)
//            } else {
//                // use a timer to repeatedly check when the ad has loaded and present it
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                    if self.interstitial!.isReady {
//                        self.interstitial?.present(fromRootViewController: self)
//                        timer.invalidate()
//                    }
//                }
//            }
//        }
//    }
//
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        var interstitials: GADInterstitial
        if String(UIDevice.current.identifierForVendor!.uuidString) == "DEF47FC4-E5F6-4286-A12C-01EAB2D74F43" {
            interstitials = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        } else {
            interstitials = GADInterstitial(adUnitID: "ca-app-pub-1247105887511638/9360843256")
        }
        interstitials.delegate = self
        interstitials.load(request)
        return interstitials
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
         interstitial = createAndLoadInterstitial()
//         print("DISMISSEDDD")
     }
}
