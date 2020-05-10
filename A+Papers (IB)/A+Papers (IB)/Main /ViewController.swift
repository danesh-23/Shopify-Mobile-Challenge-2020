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

class ViewController: UIViewController {

    @IBAction func seeibgroups(_ sender: Any) {
        guard checkReachability() else {
            networkAvailable = false
            SCLAlertView().showError(NSLocalizedString("You are not connected to the internet.", comment: ""), subTitle: NSLocalizedString("You need an internet connection to browse through our papers.", comment: ""))
            return
        }
        if groupNames.count < 3 {
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
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var hiddenErrorMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seeibgroupsbtn: UIButton!
    @IBOutlet weak var helpPagesBtn: UIButton!
    var titleNames = [String]()
    var groupNames = [String]()
    var links = [String]()
    let imageArray = ["image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg"]
    var networkAvailable = Bool()

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
    
    @IBAction func downloadedPapers(_ sender: Any) {
        if UserDefaults.standard.object(forKey: "iapPurchased") as? Bool == true {
            self.performSegue(withIdentifier: "seguetodownloaded", sender: self)
        } else {
            let alert = SCLAlertView()
            alert.addButton(NSLocalizedString("Get PaperSaver", comment: "")) {
                self.pushViewsFromNavButtons(storyboardName: "Help", vcIdentifier: "IAPViewController")
                }
            alert.showInfo(NSLocalizedString("PaperSaver Feature Not Unlocked.", comment: ""), subTitle: NSLocalizedString("You have not unlocked the PaperSaver feature yet. Click 'Get PperSaver' button below to see it :)", comment: ""))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenErrorMessage.text = NSLocalizedString("Done loading subjects. Click again :)", comment: "")
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
            Alamofire.request("https://ibresources.org/ib-past-papers/").responseString {response in
                for values in response.description.components(separatedBy: "et_pb_text_inner") {
                    if values.contains("Group") {
                        names.append(values)
                    }
                }

                for values in names {
                    self.titleNames.append(values.components(separatedBy: "</span>")[0].components(separatedBy: "\">")[1])
                    self.links.append(values.components(separatedBy: "href=")[1].components(separatedBy: "\"")[1])
                }
                
                for var values in self.titleNames {
                    values.removeSubrange(values.startIndex..<values.index(values.startIndex, offsetBy: 4))
                    self.groupNames.append(values)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetogroups" {
            let nextView = segue.destination as! GroupsTableVC
            nextView.passedOnNames = groupNames
            nextView.passedOnLinks = links
        }
    }
    
    func randomImageGenerator() -> UIImage {
        let randomNumber = Int(arc4random_uniform(UInt32(imageArray.count)))
        return UIImage(named: imageArray[randomNumber])!
    }
    
    func isAppAlreadyLaunchedOnce() {
        let defaults = UserDefaults.standard.object(forKey: "papersaverfirsttime")
        if defaults as? Bool != true {
            UserDefaults.standard.set(true, forKey: "papersaverfirsttime")
            let viewController = UIStoryboard(name: "FirstTime", bundle: nil).instantiateInitialViewController()
            if let navigator = navigationController {
                navigator.pushViewController(viewController!, animated: true)
            }
        }
        UserDefaults.standard.set(false, forKey: "firsttimeuserspopup")
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
