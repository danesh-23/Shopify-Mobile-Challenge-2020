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
    var groupName = ["Group 1&2- Literature&Language Acquisition", "Group 3 - Individuals and Societies", "Group 4 - Sciences", "Group 5 - Mathematics", "Group 6 - The Arts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupName.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = groupName[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup.removeAll()
        for keys in passedOnNames.keys {
            if groupName[indexPath.row].contains(keys) {
                if selectedGroup.isEmpty {
                    selectedGroup = passedOnNames[keys]!
                } else {
                    selectedGroup.append(contentsOf: passedOnNames[keys]!)
                }
            }
        }
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
