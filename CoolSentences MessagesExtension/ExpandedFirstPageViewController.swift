//
//  ExpandedFirstPageViewController.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-11.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class ExpandedFirstPageViewController: UIViewController {
    
    static let storyboardIdentifier = "expandedFirstPageStoryboardID"
    private var sentences : [Sentence]?
    private var suggestions = Array(Warehouse.sharedInstance().hashtags)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
