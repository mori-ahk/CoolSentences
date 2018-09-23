//
//  SentenceCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-17.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class SentenceCollectionViewCell : UICollectionViewCell {
    
    private var firstOtherTagWidthAnchor : NSLayoutConstraint?
    private var secondOtherTagWidthAnchor : NSLayoutConstraint?
    
    let bodyTextView: UILabel = {
        let TV = UILabel()
        TV.font = UIFont.systemFont(ofSize: 14)
        TV.backgroundColor = .clear
        TV.textColor = .white
        TV.clipsToBounds = true
        TV.layer.masksToBounds = false
        TV.textAlignment = .left
        TV.numberOfLines = 0
        TV.translatesAutoresizingMaskIntoConstraints = false
        return TV
    }()
    
    let firstOtherTag : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondOtherTag : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func renderCell(from sentence: Sentence) {
        self.bodyTextView.text = sentence.text
        self.firstOtherTag.text = "#\(sentence.tags[0])"
        self.secondOtherTag.text = "#\(sentence.tags[1])"
        self.sourceLabel.text = sentence.source
        self.firstOtherTagWidthAnchor?.constant = estimateFrameForText(text: sentence.tags[0], fontSize: 12).width + 40
        self.secondOtherTagWidthAnchor?.constant = estimateFrameForText(text: sentence.tags[1], fontSize: 12).width + 40
    }

    func setupViews() {
        self.addSubview(bodyTextView)
        self.addSubview(sourceLabel)
        self.addSubview(firstOtherTag)
        self.addSubview(secondOtherTag)
        
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: self.topAnchor),
            bodyTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
            bodyTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            ])
        
        firstOtherTagWidthAnchor = firstOtherTag.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            firstOtherTag.topAnchor.constraint(equalTo: self.bodyTextView.bottomAnchor, constant: 2),
            firstOtherTag.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
            firstOtherTagWidthAnchor ?? NSLayoutConstraint(),
            firstOtherTag.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        secondOtherTagWidthAnchor = secondOtherTag.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            secondOtherTag.topAnchor.constraint(equalTo: self.bodyTextView.bottomAnchor, constant: 2),
            secondOtherTag.leftAnchor.constraint(equalTo: self.firstOtherTag.rightAnchor, constant: 6),
            secondOtherTagWidthAnchor ?? NSLayoutConstraint(),
            secondOtherTag.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            sourceLabel.topAnchor.constraint(equalTo: self.firstOtherTag.bottomAnchor, constant: 2),
            sourceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6),
            sourceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            sourceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        
    }
    
    private func estimateFrameForText(text: String, fontSize: CGFloat) -> CGRect {
        let size = CGSize(width: 256, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes =  [NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
    }

}
