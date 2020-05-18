//
//  YearsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-11.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire

class YearsTableVC: UITableViewController {

    var passedOnLink = String()
    var finalYears = [String]()
    var nextPassLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedOnLink)
        Alamofire.request(passedOnLink).responseString { response in
            for values in response.description.components(separatedBy: "td>") {
                if values.contains("href") && (values.contains("May") || values.contains("Nov")) {
                    self.finalYears.append(values.components(separatedBy: "\"")[1])
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalYears.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = removeGibberish(dirtyText: finalYears[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextPassLink = passedOnLink + finalYears[indexPath.row]
        self.performSegue(withIdentifier: "seguetopapers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetopapers" {
            let nextView = segue.destination as! PapersTableVC
            nextView.passedOnLink = nextPassLink
        }
    }
}
