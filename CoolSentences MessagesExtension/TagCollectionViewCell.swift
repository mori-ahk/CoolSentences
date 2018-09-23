//
//  TagCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-16.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class TagCollectionViewCell : UICollectionViewCell {
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.masksToBounds = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        setupViews()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            ])

    }
    
}
