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
//    var paperLink = String()
//    var subjectTitle = String()
//    var yearToPassOn = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("..........\n\n\(passedOnLink)\n\n.......")
        var linkCut = [String]()
        var finalYears = [String]()
        Alamofire.request(passedOnLink).responseString {response in
            let links = response.description.components(separatedBy: "<tr class")
            for values in links {
                if values.contains("indexcolicon") {
                    linkCut.append(values)
                }
            }
            for values in linkCut {
                finalYears.append(values.components(separatedBy: "href=")[1])
            }
            linkCut.removeAll()
            for values in finalYears {
                linkCut.append(values.components(separatedBy: "\"")[1])
            }
            linkCut.removeFirst()
            linkCut.removeFirst()
            DispatchQueue.main.async {
                self.finalYears = linkCut
                self.tableView.reloadData()
            }
        }
        
//        Alamofire.request(passedOnLink).responseString { response in
//            for values in response.description.components(separatedBy: "td>") {
//                if values.contains("href") && (values.contains("May") || values.contains("Nov")) {
//                    self.finalYears.append(values.components(separatedBy: "\"")[1])
//                }
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalYears.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = finalYears[indexPath.row].replacingOccurrences(of: "%20", with: " ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextPassLink = passedOnLink + finalYears[indexPath.row]
//        print(nextPassLink)
        self.performSegue(withIdentifier: "seguetopapers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetopapers" {
            let nextView = segue.destination as! PapersTableVC
            nextView.passedOnLink = nextPassLink
        }
    }
}
