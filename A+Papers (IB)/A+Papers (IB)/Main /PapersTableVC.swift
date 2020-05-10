//
//  PapersTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-11.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import StoreKit

class PapersTableVC: UITableViewController {

    var passedOnLink = String()
    var passedOnYear = String()
    var paperLinks = [String]()
    var subjectTitle = String()
    var pdfLink = String()
    var paperName = String()
    var downloadedFileName = String()
    var documentInteractionController = UIDocumentInteractionController()
    let itemsObject = UserDefaults.standard.object(forKey: "iapPurchased")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(passedOnLink)
        subjectTitle = String(subjectTitle[subjectTitle.startIndex ..< subjectTitle.index(subjectTitle.endIndex, offsetBy: -4)])
        documentInteractionController.delegate = self as UIDocumentInteractionControllerDelegate
//        print(passedOnYear)
        var linkCut = [String]()
        var finalPapers = [String]()
        Alamofire.request(passedOnLink).responseString {response in
            let links = response.description.components(separatedBy: "<tr class")
            for values in links {
                if values.contains("indexcolicon") {
                    linkCut.append(values)
                }
            }
            for values in linkCut {
                finalPapers.append(values.components(separatedBy: "href=")[1])
            }
            linkCut.removeAll()
            for values in finalPapers {
                linkCut.append(values.components(separatedBy: "\"")[1])
            }
            finalPapers.removeAll()
            for values in linkCut {
                if values.contains(".pdf") {
                    finalPapers.append(values)
                }
            }
            DispatchQueue.main.async {
                self.paperLinks = finalPapers
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paperLinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var displayName = [String]()
        for values in paperLinks {
            let name = values.replacingOccurrences(of: "\(subjectTitle)_", with: "")
            displayName.append((name.replacingOccurrences(of: ".pdf", with: "")).replacingOccurrences(of: "_", with: " "))
        }
        cell.textLabel?.text = displayName[indexPath.row].capitalized
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pdfLink = passedOnLink + paperLinks[indexPath.row]
        paperName = paperLinks[indexPath.row].capitalized
        self.performSegue(withIdentifier: "seguetowebview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetowebview" {
            let nextView = segue.destination as! PDFViewController
            nextView.pdfLink = pdfLink
            let name = paperName.replacingOccurrences(of: ".Pdf", with: "")
            nextView.pdfFileName = name.replacingOccurrences(of: ".pdf", with: "")
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
        {
            var displayName = [String]()
            for values in paperLinks {
                let name = values.replacingOccurrences(of: "\(subjectTitle)_", with: "")
                displayName.append((name.replacingOccurrences(of: ".pdf", with: "")).replacingOccurrences(of: "_", with: " "))
            }
            var array = [UITableViewRowAction]()
            // 1
            downloadedFileName = displayName[indexPath.row].capitalized

            let shareAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: NSLocalizedString("Download", comment: "") , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
                // 2
                if self.itemsObject as? Bool == true {

                    let downloadMenu = UIAlertController(title: nil, message: NSLocalizedString("Download this paper", comment: ""), preferredStyle: .alert)

                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)

                    downloadMenu.addAction(UIAlertAction(title: NSLocalizedString("Download", comment: ""), style: UIAlertAction.Style.destructive, handler: { action in self.storeAndShare(withURLString: "\(self.passedOnLink)\(self.paperLinks[indexPath.row])")}))
//                    print(self.passedOnLink + self.paperLinks[indexPath.row])
                    downloadMenu.addAction(cancelAction)

                    self.present(downloadMenu, animated: true, completion: nil)
                } else {
                    let alert = SCLAlertView()
                    alert.addButton(NSLocalizedString("Get PaperSaver", comment: "")) {
                        self.pushViewsFromNavButtons(storyboardName: "Help", vcIdentifier: "IAPViewController")
                    }
                    alert.showInfo(NSLocalizedString("PaperSaver Feature Not Unlocked", comment: ""), subTitle: NSLocalizedString("You have not unlocked the PaperSaver feature yet, click below to download as many papers as you want for offline use :)", comment: ""))
                }
            })
            // 3
            let rateAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: NSLocalizedString("Rate", comment: "") , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
                // 4
                let alert = SCLAlertView()
                alert.addButton(NSLocalizedString("Rate Us :)", comment: "")) {
                    SKStoreReviewController.requestReview()
                }
                alert.showInfo(NSLocalizedString("Rate this App", comment: ""), subTitle: NSLocalizedString("Click 'Rate' to give us a positive rating if you feel this app helps you", comment: ""))
            })
            // 5
            array = [shareAction, rateAction]
            return array
        }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func getDownloadedFileName(string: String) -> String {
        return (string.components(separatedBy: "/")[7])
    }
}


extension PapersTableVC {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }

    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
//        print(url)
        /// START YOUR ACTIVITY INDICATOR HERE
        //        print(url)
        let title = (subjectTitle.components(separatedBy: "_"))
        var abbrev = String()
        for values in title {
            abbrev = "\(abbrev)\(values.first ?? "a")"
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let fileManager = FileManager.default
            do {
                let documentDirectory = try fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let fileURL = documentDirectory.appendingPathComponent("papers")
                try fileManager.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
                let finalURL = fileURL.appendingPathComponent("\(abbrev.uppercased())-\(self.passedOnYear)-\(self.downloadedFileName).pdf")
                try data.write(to: finalURL)

//                print(finalURL)
                DispatchQueue.main.async {
                    self.share(url: finalURL)
                }
            } catch {
                SCLAlertView().showError(NSLocalizedString("Error Downloading File", comment: ""), subTitle: NSLocalizedString(error.localizedDescription, comment: ""))
                print(error)
            }
        }.resume()
    }
}

extension PapersTableVC: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}


