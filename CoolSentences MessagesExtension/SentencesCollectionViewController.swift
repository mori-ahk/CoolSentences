//
//  SentencesCollectionViewController.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-17.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "sentenceCellIdentifier"

class SentencesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var allSenteces : [Sentence]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SentenceCollectionViewCell.self, forCellWithReuseIdentifier: "sentenceCellIdentifier")
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSenteces?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentenceCollectionViewCell
        cell.bodyTextView.text = "\(allSenteces?[indexPath.row].text ?? "")"
        cell.sourceLabel.text = "\(allSenteces?[indexPath.row].source ?? "")"
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = allSenteces?[indexPath.row].text ?? ""
        height = estimateFrameForText(text: text).height + 35
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 256, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], context: nil)
        
    }
    
}
