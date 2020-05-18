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

    var passedOnSubjects = [String]()
    var chosenSubject = String()
    var nextPassLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return passedOnSubjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = removeGibberish(dirtyText: passedOnSubjects[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSubject = passedOnSubjects[indexPath.row]
        self.performSegue(withIdentifier: "seguetovariant", sender: self)
//        print(chosenSubject)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetovariant" {
            let nextView = segue.destination as! VariantsTableVC
            nextView.passedOnLink = "https://freeexampapers.com/exam-papers/IB/" + chosenSubject
        }
    }
}
extension UITableViewController {
    func removeGibberish(dirtyText: String) -> String {         // function to remove unnecessary formatting text in html/CSS
        
        return dirtyText.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "-", with: " ").replacingOccurrences(of: "/", with: "")
    }
}
