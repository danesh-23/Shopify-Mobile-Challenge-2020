//
//  SubjectsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-10.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire

class SubjectsTableVC: UITableViewController {
   
    var titles = [String]()
    var chosenSubject = String()
    var passedOnGroup = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         this website simply appends the clicked page title to the current link as the link for the new page
        Alamofire.request(passedOnGroup).responseString { response in
            let name = response.description.components(separatedBy: "href=")
            var links = [String]()
            for values in name {
                links.append(values.components(separatedBy: "><img")[0].components(separatedBy: "/")[0])
            }
            for values in links {
                if values.contains("HL") || values.contains("SL") {
                    DispatchQueue.main.async {
                        self.titles.append("\(values.replacingOccurrences(of: "\"", with: ""))/")
                        self.titles = Array(Set(self.titles)).sorted()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = removeGibberish(dirtyText: titles[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSubject = titles[indexPath.row]
        self.performSegue(withIdentifier: "seguetoyears", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetoyears" {
            let nextView = segue.destination as! YearsTableVC
            nextView.passedOnLink = passedOnGroup + "/" + chosenSubject
        }
    }
}
extension UITableViewController {
    // function to remove unnecessary formatting text in html/CSS
    func removeGibberish(dirtyText: String) -> String {         
        let clean = dirtyText.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "-", with: " ").replacingOccurrences(of: "/", with: "")
        let foreign =  clean.replacingOccurrences(of: "%c3%ad", with: "í").replacingOccurrences(of: "%c3%89", with: "É").replacingOccurrences(of: "%c3%b3", with: "ó").replacingOccurrences(of: "370", with: "Business and Organization")
        return foreign.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: " and ", with: " & ")
    }
}
