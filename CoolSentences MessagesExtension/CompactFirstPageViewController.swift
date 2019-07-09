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
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Welcome to EZPZ"
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    static let storyboardIdentifier = "compactFirstPageStoryboardID"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.requestPresentationSyle()
    }
    
    private func setupViews() {
        self.view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: self.searchBar.topAnchor, constant: -25),
            welcomeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width)
            ])
    }
}

protocol CompactFirstPageViewControllerDelegate: class {
    func requestPresentationSyle()
}
