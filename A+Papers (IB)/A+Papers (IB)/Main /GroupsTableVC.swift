//
//  SubjectsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-09.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit

class GroupsTableVC: UITableViewController {

    var selectedGroup = String()
    var passedOnLinks = [String]()
    var groupName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = groupName[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for values in passedOnLinks {
            if values.contains(makeTextHtmlSearchable(text: groupName[indexPath.row])) {
                selectedGroup = "https://www.ibdocuments.com/IB%20PAST%20PAPERS%20-%20SUBJECT/\(values)"
                self.performSegue(withIdentifier: "seguetosubjects", sender: self)
                break
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetosubjects" {
            let nextView = segue.destination as! SubjectsTableVC
            nextView.passedOnGroup = selectedGroup
        }
    }
    
    func makeTextHtmlSearchable(text: String) -> String {
        let spacesAdded = text.replacingOccurrences(of: " ", with: "%20")
        return spacesAdded.replacingOccurrences(of: "&", with: "and")
    }
}
