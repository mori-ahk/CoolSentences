//
//  SentenceCollectionViewCell.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-17.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

class SentenceCollectionViewCell: UICollectionViewCell {
    private var tags: [EdgeInsetLabel] = []
    private var tagsStackView: UIStackView = UIStackView()
    private var bodyLabel: EdgeInsetLabel = EdgeInsetLabel()
    private var sourceLabel: EdgeInsetLabel = EdgeInsetLabel()
    private var wholeStackView: UIStackView = UIStackView()
    
    private func initBodyLabel() {
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        bodyLabel.backgroundColor = .clear
        bodyLabel.textColor = .white
        bodyLabel.textAlignment = .left
        bodyLabel.numberOfLines = 0
        bodyLabel.layer.cornerRadius = 10
        bodyLabel.clipsToBounds = true
        bodyLabel.backgroundColor = #colorLiteral(red: 0.05303675681, green: 0.5231412649, blue: 0.9969810843, alpha: 1)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.textInsets = UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6)
    }
    
    private func initSourceLabel() {
        sourceLabel.backgroundColor = .clear
        sourceLabel.textColor = .black
        sourceLabel.font = UIFont.systemFont(ofSize: 11)
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initTags() {
        tags = (0...2).map { _ in EdgeInsetLabel() }
        tags.forEach { eachLabel in
            eachLabel.textInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
            eachLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            eachLabel.textAlignment = .center
            eachLabel.textColor = .black
            eachLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTagsStackView() {
        initTags()
        tagsStackView = UIStackView(arrangedSubviews: tags)
        tagsStackView.spacing = 5
        tagsStackView.axis = .horizontal
        tagsStackView.alignment = .fill
        tagsStackView.distribution = .fill
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupWholeStackView() {
        initBodyLabel()
        initSourceLabel()
        setupTagsStackView()
        wholeStackView = UIStackView(arrangedSubviews: [bodyLabel, tagsStackView, sourceLabel])
        wholeStackView.spacing = 10
        wholeStackView.axis = .vertical
        wholeStackView.alignment = .leading
        wholeStackView.distribution = .fill
        wholeStackView.translatesAutoresizingMaskIntoConstraints = false
        wholeStackView.layoutMargins = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    }

    private func setupConstraint() {
        addSubview(wholeStackView)
        NSLayoutConstraint.activate([
            wholeStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            wholeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            wholeStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            wholeStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            ])
    }
    
    private func setupView() {
        setupWholeStackView()
        setupConstraint()
    }
    
    func renderCell(from sentence: Sentence) {
        for (index, tag) in sentence.tags.enumerated() {
            if index < tags.count {
                tags[index].text = "#\(tag)"
            }
        }
        
        self.tags.forEach { tagLabel in
            guard tagLabel.text != nil else {
                tagLabel.isHidden = true
                return
            }
        }
        
        bodyLabel.text = sentence.text
        sourceLabel.text = sentence.source
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

extension EdgeInsetLabel {
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }

    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}
