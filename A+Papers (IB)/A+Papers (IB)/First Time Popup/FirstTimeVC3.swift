//
//  FirstTimeVC3.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-03-20.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class FirstTimeVC3: UIViewController {

    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: NSLocalizedString("Important Features Introduced", comment: ""))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        labelView.attributedText = attributedString

        textView1.text = NSLocalizedString("We present to you, PaperSaver : Your ultimate saviour for accessing and viewing the papers without an internet connection.", comment: "")
        textView2.text = NSLocalizedString("You may get more information on this by clicking on the Help button in the menu bar at the top of the screen.", comment: "")
    }

}
