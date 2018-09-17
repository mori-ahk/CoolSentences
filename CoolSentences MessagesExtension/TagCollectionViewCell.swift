//
//  TagCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-16.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class TagCollectionViewCell : UICollectionViewCell {
    
    weak var delegate : TagCollectionViewCellDelegate?
    
    let textView : UITextView = {
        let TV = UITextView()
        TV.font = UIFont.systemFont(ofSize: 11)
        TV.backgroundColor = .clear
        TV.textColor = .black
        TV.isEditable = false
        TV.backgroundColor = .clear
        TV.isScrollEnabled = false
        TV.clipsToBounds = true
        TV.layer.masksToBounds = false
        TV.textAlignment = .center
        TV.translatesAutoresizingMaskIntoConstraints = false
        return TV
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        setupViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnTap))
        textView.addGestureRecognizer(tap)
    }
    
    @objc func handleOnTap() {
        delegate?.handleTap(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            ])
        
    }
    
}

protocol TagCollectionViewCellDelegate : class {
    func handleTap(_ sender: TagCollectionViewCell)
}
