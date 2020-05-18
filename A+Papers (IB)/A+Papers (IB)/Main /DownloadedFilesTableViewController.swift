//
//  DownloadedFilesTableViewController.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-03-21.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class DownloadedFilesTableViewController: UITableViewController {
    
    var savedFiles = [URL]()
    var documentInteractionController = UIDocumentInteractionController()
    let fileManager = FileManager.default
    let titleName = NSLocalizedString("Downloaded Papers", comment: "")
//        var interstitialAd: GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//            interstitialAd = createAndLoadInterstitial()
        self.navigationController?.navigationBar.topItem?.title = titleName
        documentInteractionController.delegate = self as UIDocumentInteractionControllerDelegate
        let documentsURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("papers")
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)

            DispatchQueue.main.async {
                self.savedFiles = fileURLs
                self.tableView.reloadData()
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("Back", comment: "")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSaved", for: indexPath)
        cell.textLabel?.text = savedFiles[indexPath.row].lastPathComponent
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        documentInteractionController.dismissPreview(animated: true)
        self.share(url: savedFiles[indexPath.row])
        print(savedFiles[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            do {
                try fileManager.removeItem(at: savedFiles[indexPath.row])
            }
            catch let error as NSError {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.viewDidLoad()
            }
        }
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension DownloadedFilesTableViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
}

extension DownloadedFilesTableViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
