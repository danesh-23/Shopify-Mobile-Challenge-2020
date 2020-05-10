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

    var passedOnlink = String()
    var titles = [String]()
    var chosenSubject = String()
    var subjectTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this website simply appends the clicked page title to the current link as the link for the new page
        Alamofire.request(passedOnlink).responseString { response in
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
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row].replacingOccurrences(of: "/", with: "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSubject = passedOnlink + titles[indexPath.row]
        subjectTitle = titles[indexPath.row]
        self.performSegue(withIdentifier: "seguetoyears", sender: self)
//        print(chosenSubject)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetoyears" {
            let nextView = segue.destination as! YearsTableVC
            nextView.passedOnLink = chosenSubject
            nextView.subjectTitle = subjectTitle
        }
    }

}
