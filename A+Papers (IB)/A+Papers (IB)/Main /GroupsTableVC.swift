//
//  SubjectsTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2019-12-09.
//  Copyright © 2019 Danesh Rajasolan. All rights reserved.
//

import UIKit

class GroupsTableVC: UITableViewController {

    var passedOnNames = [String]()
    var passedOnLinks = [String]()
    var titleName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(names)
        for values in passedOnNames {
            titleName.append(removeGibberish(dirtyText: ((values.components(separatedBy: "<strong>")[1]).replacingOccurrences(of: "<span>", with: "")).components(separatedBy: "</strong>")[0]).replacingOccurrences(of: "Langauage", with: "Language"))
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleName.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titleName[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for values in passedOnLinks {
//            print(makeTextHtmlSearchable(text: titleName[indexPath.row]))
            if values.contains(makeTextHtmlSearchable(text: titleName[indexPath.row])) {
                passedOnNames = [values]
                self.performSegue(withIdentifier: "seguetosubjects", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetosubjects" {
            let nextView = segue.destination as! SubjectsTableVC
            nextView.passedOnlink = passedOnNames[0]
        }
    }
    
    func removeGibberish(dirtyText: String) -> String {         // function to remove unnecessary formatting text in html/CSS
        return dirtyText.replacingOccurrences(of: "&amp;", with: "&")
    }
    
    func makeTextHtmlSearchable(text: String) -> String {
        let weirdRemoval = text.replacingOccurrences(of: "The", with: "")
        let spacesAdded = weirdRemoval.replacingOccurrences(of: " ", with: "%20")
        return spacesAdded.replacingOccurrences(of: "&", with: "and")
    }
}
