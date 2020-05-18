//
//  VariantsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-05-18.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire

class VariantsTableVC: UITableViewController {

    var passedOnLink = String()
    var variants = [String]()
    var extraView = true
    var nextPassLink = String()
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(passedOnLink).responseString { response in
            for values in response.description.components(separatedBy: "td>") {
                if values.contains("Standard") || values.contains("Higher") {
                    self.variants.append(values.components(separatedBy: "\"")[1])
                    self.extraView = false
                } else if self.extraView && values.contains(self.passedOnLink.components(separatedBy: "/")[5]) {
                    if (values.components(separatedBy: "\"")[1].contains(self.passedOnLink.components(separatedBy: "/")[5])) {
                        self.variants.append(values.components(separatedBy: "\"")[1])
                    }
                }
            }
            
            if self.extraView {
                self.navTitle.title = "Variant"
            } else {
                self.navTitle.title = "Level"
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variants.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = removeGibberish(dirtyText: variants[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextPassLink = passedOnLink + variants[indexPath.row]
        if extraView {
            self.performSegue(withIdentifier: "seguetolevels", sender: self)
        } else {
            self.performSegue(withIdentifier: "seguetoyears", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetolevels" {
            let nextView = segue.destination as! LevelTableVC
            nextView.passedOnLink = nextPassLink
        }
        else if segue.identifier == "seguetoyears" {
            let nextView = segue.destination as! YearsTableVC
            nextView.passedOnLink = nextPassLink
        }
    }
}
