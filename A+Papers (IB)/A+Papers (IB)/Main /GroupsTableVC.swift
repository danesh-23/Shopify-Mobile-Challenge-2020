//
//  SubjectsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-09.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit

class GroupsTableVC: UITableViewController {

    var passedOnNames = [String: [String]]()
    var selectedGroup = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return passedOnNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = passedOnNames.keys.sorted()[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = passedOnNames[passedOnNames.keys.sorted()[indexPath.row]]!
//        print(selectedGroup)
        self.performSegue(withIdentifier: "seguetosubjects", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetosubjects" {
            let nextView = segue.destination as! SubjectsTableVC
            nextView.passedOnSubjects = selectedGroup
        }
    }
    
    func makeTextHtmlSearchable(text: String) -> String {
        let weirdRemoval = text.replacingOccurrences(of: "The", with: "")
        let spacesAdded = weirdRemoval.replacingOccurrences(of: " ", with: "%20")
        return spacesAdded.replacingOccurrences(of: "&", with: "and")
    }
}
