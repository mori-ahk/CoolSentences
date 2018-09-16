//
//  TagCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-16.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class TagCollectionViewCell : UICollectionViewCell {
    
    let textView : UITextView = {
        let TV = UITextView()
        TV.font = UIFont.systemFont(ofSize: 12)
        TV.backgroundColor = .clear
        TV.textColor = .white
        TV.isEditable = false
        TV.backgroundColor = .black
        TV.isScrollEnabled = false
        TV.layer.cornerRadius = 10
        TV.clipsToBounds = true
        TV.layer.masksToBounds = false
        TV.textAlignment = .center
        TV.translatesAutoresizingMaskIntoConstraints = false
        return TV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
    }
}
