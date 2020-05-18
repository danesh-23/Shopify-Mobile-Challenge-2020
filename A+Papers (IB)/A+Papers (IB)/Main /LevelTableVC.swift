//
//  LevelTableVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-05-18.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit
import Alamofire

class LevelTableVC: UITableViewController {
    
    var passedOnLink = String()
    var levels = [String]()
    var nextPassLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedOnLink)
        Alamofire.request(passedOnLink).responseString { response in
            for values in response.description.components(separatedBy: "td>") {
                if values.contains("href") {
                    if values.contains("Standard") || values.contains("Higher") {
                        self.levels.append(values.components(separatedBy: "\"")[1])
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = removeGibberish(dirtyText: levels[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextPassLink = passedOnLink + levels[indexPath.row]
        self.performSegue(withIdentifier: "segueleveltoyears", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueleveltoyears" {
            let nextView = segue.destination as! YearsTableVC
            nextView.passedOnLink = nextPassLink
        }
    }
}
