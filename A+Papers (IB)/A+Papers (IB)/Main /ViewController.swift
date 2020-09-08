//
//  ViewController.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-08.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import SCLAlertView
import FirebaseAnalytics

class ViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var hiddenErrorMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seeibgroupsbtn: UIButton!
    @IBOutlet weak var helpPagesBtn: UIButton!
    var titleNames = [String]()
//    var groupNames = [String]()
//    var subjectGroups = [String: [String]]()
    let imageArray = ["image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg"]
    var networkAvailable = Bool()
    var links = [String]()

    private let reachability = SCNetworkReachabilityCreateWithName(nil, "https://pastpapers.papacambridge.com/?dir=AQA/A-Level")
    
    private func checkReachability() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            return true
        } else if (!isNetworkReachable(with: flags)) {
            SCLAlertView().showError("No Active Internet Connection", subTitle: "Your internet connection appears to be offline. Please connect to a valid Wifi or mobile network to continue.")
            return false
        }
        return true
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkAvailable = checkReachability()
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("A+Papers", comment: "")
    }
    
    @IBAction func seeibgroups(_ sender: Any) {
        guard checkReachability() else {
            networkAvailable = false
            SCLAlertView().showError(NSLocalizedString("You are not connected to the internet.", comment: ""), subTitle: NSLocalizedString("You need an internet connection to browse through our papers.", comment: ""))
            return
        }
        if titleNames.count < 3 {
            hiddenErrorMessage.isHidden = false
        } else {
            self.performSegue(withIdentifier: "seguetogroups", sender: self)
            hiddenErrorMessage.isHidden = true
        }
    }
    
    @IBAction func helpPageBtn(_ sender: Any) {
        let viewController = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "pageViewController")
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func downloadedPapers(_ sender: Any) {
        if UserDefaults.standard.object(forKey: "iapPurchased") as? Bool == true {
            self.performSegue(withIdentifier: "seguetodownloaded", sender: self)
        } else {
            let alert = SCLAlertView()
            alert.addButton(NSLocalizedString("Get PaperSaver", comment: "")) {
                self.pushViewsFromNavButtons(storyboardName: "Help", vcIdentifier: "IAPViewController")
                }
            alert.showInfo(NSLocalizedString("PaperSaver Feature Not Unlocked.", comment: ""), subTitle: NSLocalizedString("You have not unlocked the PaperSaver feature yet. Click 'Get PaperSaver' button below to see it :)", comment: ""))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenErrorMessage.text = NSLocalizedString("Loading subjects... Try again :)", comment: "")
        hiddenErrorMessage.isHidden = true
        isAppAlreadyLaunchedOnce()
        networkAvailable = checkReachability()
        titleText.text = NSLocalizedString("Welcome to A+Papers", comment: "")
        mainText.text = NSLocalizedString("Welcome to A+Papers. We offer resources for IB students doing the International Baccalaureate programme.\n\nWe cater specifically as a one-stop-all for you to find any past exam paper for revision that you could possibly want.", comment: "")
        seeibgroupsbtn.setTitle(NSLocalizedString("See IB Papers", comment: ""), for: .normal)
        helpPagesBtn.setTitle(NSLocalizedString("Help", comment: ""), for: .normal)
        
        var names = [String]()
        imageView.image = randomImageGenerator()
        if networkAvailable {
//            if let filePath = Bundle.main.path(forResource: "papers", ofType: "txt") {
//                do {
//                    let content = try String(contentsOfFile: filePath)
//    //                print(content)
//                    var count = 0
//                    let array = content.components(separatedBy: ",")
//                    while count < array.count {
//                        let key = array[count+1].replacingOccurrences(of: "\n", with: "")
//                        if subjectGroups[key] == nil {
//                            subjectGroups[key] = [array[count].replacingOccurrences(of: "\n", with: "")]
//                        } else {
//                            subjectGroups[key]?.append(array[count].replacingOccurrences(of: "\n", with: ""))
//                        }
//                        count += 2
//                    }
//                } catch {
//                    print("couldnt get contents")
//                }
////                print(subjectGroups)
//            }
//            names.removeFirst()
//            names.removeFirst()
            Alamofire.request("https://www.ibdocuments.com/IB%20PAST%20PAPERS%20-%20SUBJECT/").responseString { response in
                for values in response.description.components(separatedBy: "a href") {
                    
                    if values.contains("Group") {
                        names.append(values)
                    }
                }
//                print(names)

                for values in names {
                    if values.contains("/"), !self.links.contains(values.components(separatedBy: "/")[0].replacingOccurrences(of: "=\"", with: "")) {
                        let clean = values.components(separatedBy: "/")[0].replacingOccurrences(of: "=\"", with: "")
                        self.titleNames.append(clean.replacingOccurrences(of: "%20", with: " "))
                        self.links.append(clean)
                    }
                }
                
               // print(self.titleNames)
            //    print(self.links)

            }
        }
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: [
        "screenName": "ViewController" as NSObject,
        "full_text": "User opened app to first page" as NSObject
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetogroups" {
            let nextView = segue.destination as! GroupsTableVC
            nextView.passedOnLinks = links
            nextView.groupName = titleNames
        }
    }
    
    func randomImageGenerator() -> UIImage {
        let randomNumber = Int(arc4random_uniform(UInt32(imageArray.count)))
        return UIImage(named: imageArray[randomNumber])!
    }
    
    func isAppAlreadyLaunchedOnce() {
        let defaults = UserDefaults.standard.object(forKey: "firsttimeuserspopup")
        let paperSaverDefaults = UserDefaults.standard.object(forKey: "papersaverreminder")
        if defaults as? Bool == true && paperSaverDefaults as? Bool == true {
            print("")
        } else if defaults as? Bool == true && paperSaverDefaults as? Bool != true {
            let alert = SCLAlertView()
            alert.addButton("See PaperSaver Feature") {
                let storyboard = UIStoryboard(name: "Help", bundle: nil)
                let popup = storyboard.instantiateInitialViewController()
                self.present(popup!, animated: true, completion: nil)
            }
            alert.showInfo("Want to see our latest PaperSaver feature?", subTitle: "Download any papers you want so you don't ever need an internet connection to study :)")
            UserDefaults.standard.set(true, forKey: "papersaverreminder")
        } else {
            UserDefaults.standard.set(true, forKey: "firsttimeuserspopup")
            let viewController = UIStoryboard(name: "FirstTime", bundle: nil).instantiateInitialViewController()
            if let navigator = navigationController {
                navigator.pushViewController(viewController!, animated: true)
            }
            Analytics.logEvent("firstTimeGuideOpened", parameters: [
            "screenName": "ViewController" as NSObject,
            "full_text": "User opened app for first time" as NSObject
            ])
        }
        UserDefaults.standard.set(false, forKey: "papersaverfirst")
        UserDefaults.standard.set(false, forKey: "papersaversecond")
        UserDefaults.standard.set(false, forKey: "papersaverfirsttime")
    }
}

extension UIViewController {
    func pushViewsFromNavButtons(storyboardName: String, vcIdentifier: String){
        let viewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: vcIdentifier)
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
}
