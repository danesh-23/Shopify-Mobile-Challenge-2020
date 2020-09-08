//
//  SubjectsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-09.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit

class GroupsTableVC: UITableViewController {

//    var passedOnNames = [String: [String]]()
    var selectedGroup = String()
    var passedOnLinks = [String]()
    var groupName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(passedOnNames)
//        print(names)
//        for values in passedOnNames {
//            titleName.append(removeGibberish(dirtyText: ((values.components(separatedBy: "<strong>")[1]).replacingOccurrences(of: "<span>", with: "")).components(separatedBy: "</strong>")[0]).replacingOccurrences(of: "Langauage", with: "Language"))
//        }
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
//        selectedGroup.removeAll()
//        for keys in passedOnNames.keys {
//            print(keys)
//            if groupName[indexPath.row].contains(keys) {
//                if selectedGroup.isEmpty {
//                    selectedGroup = passedOnNames[keys]!
//                } else {
//                    selectedGroup.append(contentsOf: passedOnNames[keys]!)
//                }
//            }
//        }
//        print(selectedGroup)
//        self.performSegue(withIdentifier: "seguetosubjects", sender: self)
        
        
        for values in passedOnLinks {
            if values.contains(makeTextHtmlSearchable(text: groupName[indexPath.row])) {
                selectedGroup = "https://www.ibdocuments.com/IB%20PAST%20PAPERS%20-%20SUBJECT/\(values)"
                self.performSegue(withIdentifier: "seguetosubjects", sender: self)
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
        let weirdRemoval = text.replacingOccurrences(of: "The", with: "")
        let spacesAdded = weirdRemoval.replacingOccurrences(of: " ", with: "%20")
        return spacesAdded.replacingOccurrences(of: "&", with: "and")
    }
}
