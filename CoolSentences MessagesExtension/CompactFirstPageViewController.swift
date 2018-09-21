//
//  CompactFirstPageViewController.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-11.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class CompactFirstPageViewController : UIViewController, UISearchBarDelegate {
    
    weak var delegate : CompactFirstPageViewControllerDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    static let storyboardIdentifier = "compactFirstPageStoryboardID"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.requestPresentationSyle()
    }
    
    
}

protocol CompactFirstPageViewControllerDelegate: class {
    func requestPresentationSyle()
}
