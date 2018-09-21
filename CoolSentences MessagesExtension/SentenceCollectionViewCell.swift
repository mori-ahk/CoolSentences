//
//  SentenceCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-17.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class SentenceCollectionViewCell : UICollectionViewCell {
    
    
    let bodyTextView: UILabel = {
        let TV = UILabel()
        TV.font = UIFont.systemFont(ofSize: 12)
        TV.backgroundColor = .clear
        TV.textColor = .white
        TV.clipsToBounds = true
        TV.layer.masksToBounds = false
        TV.textAlignment = .left
        TV.numberOfLines = 0
        TV.translatesAutoresizingMaskIntoConstraints = false
        return TV
    }()
    
    let sourceLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        self.addSubview(bodyTextView)
        self.addSubview(sourceLabel)
        
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: -2),
            bodyTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
            bodyTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            ])
        
        NSLayoutConstraint.activate([
            sourceLabel.topAnchor.constraint(equalTo: self.bodyTextView.bottomAnchor, constant: 2),
            sourceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
            sourceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            sourceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        
    }
    

}
