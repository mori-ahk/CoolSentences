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
    let cellIdentifier = "suggestionCell"
    private var sentences = [Sentence]()
    private var suggestions = Array(Warehouse.sharedInstance().hashtags)
    private var filteredResult : [String]?
    private var selectedTags = [String]()
    private var tagsCollectionViewHeightConstraint : NSLayoutConstraint?
    private var searchBarWidthConstraint : NSLayoutConstraint?
    weak var delegate : ExpandedFirstPageViewControllerDelegate?
    
    var searchController : UISearchController! {
        didSet {
            searchController.view.backgroundColor = .clear
            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchController.searchBar.backgroundColor = .red
        }
    }
    
    lazy var tagsCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let rect = CGRect(x: 0, y: self.searchController.searchBar.frame.height, width: self.view.frame.width, height: 10)
        let cv = UICollectionView(frame: rect, collectionViewLayout: layout)
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var sentencesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let CV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        CV.register(SentenceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        CV.delegate = self
        CV.dataSource = self
        CV.backgroundColor = .white
        CV.isHidden = selectedTags.count == 0 ? true : false
        CV.translatesAutoresizingMaskIntoConstraints = false
        return CV
        
    }()
    
    let goButton: UIButton = {
       let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.isHidden = false
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onGoButton), for: .touchUpInside)
        return button
    }()
    
    
    @objc func onGoButton() {
        sentences = Warehouse.sharedInstance().getSentences(withHashtags: selectedTags)
        UIView.animate(withDuration: 0.3) {
            self.suggestionsTableView.alpha = 0
            self.sentencesCollectionView.alpha = 1
        }
        self.sentencesCollectionView.isHidden = false
        sentencesCollectionView.reloadData()
    }
    
    @IBOutlet weak var suggestionsTableView: UITableView! {
        didSet {
            suggestionsTableView.delegate = self
            suggestionsTableView.dataSource = self
            suggestionsTableView.backgroundColor = .yellow
            suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupViews() {
        self.view.addSubview(searchController.searchBar)
        self.view.addSubview(tagsCollectionView)
        self.view.addSubview(suggestionsTableView)
        self.view.addSubview(sentencesCollectionView)
        self.view.addSubview(goButton)
        
        NSLayoutConstraint.activate([
            suggestionsTableView.topAnchor.constraint(equalTo: self.tagsCollectionView.bottomAnchor, constant: 4),
            suggestionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            suggestionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            suggestionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            ])
        
        NSLayoutConstraint.activate([
            sentencesCollectionView.topAnchor.constraint(equalTo: self.tagsCollectionView.bottomAnchor, constant: 4),
            sentencesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sentencesCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            sentencesCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            ])
        
        searchBarWidthConstraint = searchController.searchBar.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchBarWidthConstraint ?? NSLayoutConstraint(),
            searchController.searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchController.searchBar.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        NSLayoutConstraint.activate([
            goButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            goButton.leftAnchor.constraint(equalTo: self.searchController.searchBar.rightAnchor),
            goButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            goButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        tagsCollectionViewHeightConstraint = tagsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.searchController.searchBar.frame.height),
            tagsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tagsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tagsCollectionViewHeightConstraint ?? NSLayoutConstraint()
            ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeSearchController()
        setupViews()
    }
    
    
}

extension ExpandedFirstPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredResult?.count ?? 0
        }
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier , for: indexPath)
        cell.textLabel?.text = isFiltering() ? "\(filteredResult?[indexPath.row] ?? "")" : "\(suggestions[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTag = isFiltering() ? filteredResult?[indexPath.row] : suggestions[indexPath.row]
        if !selectedTags.contains(selectedTag ?? "") {
            selectedTags.append("#\(selectedTag ?? "")" )
            UIView.animate(withDuration: 0.3) {
                self.tagsCollectionView.reloadData()
                let height : CGFloat = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.tagsCollectionViewHeightConstraint?.constant = height
                self.searchBarWidthConstraint?.constant = self.view.frame.width - 70
                self.goButton.alpha = 1
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Suggestions" : ""
    }

}

extension ExpandedFirstPageViewController : UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: Add Search bar
    func arrangeSearchController() {
        searchController = UISearchController(searchResultsController : nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = .white
        self.definesPresentationContext = true
        
    }
    
    
    //MARK: Search Bar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        goButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.suggestionsTableView.alpha = 1
            self.sentencesCollectionView.alpha = 0
        }
        searchBarWidthConstraint?.constant = self.view.frame.width
        searchController.searchBar.showsCancelButton = false
        suggestionsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        goButton.isHidden = false
        searchBarWidthConstraint?.constant = self.view.frame.width - 70
        suggestionsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isFiltering() {
            suggestionsTableView.reloadData()
        }
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchController(searchBar: searchController.searchBar)
    }
    
    private func filterSearchController( searchBar: UISearchBar) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        searchForTags(with: searchText)
        suggestionsTableView.reloadData()
    }
    
    
    //MARK: - Helper Functions For Search Bar
    
    private func searchForTags(with queryString: String) {
        filteredResult = queryString.isEmpty ? suggestions : suggestions.filter({
            return $0.lowercased().contains(queryString)
        })
    }

    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension ExpandedFirstPageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagsCollectionView {
        return selectedTags.count
        } else {
            return sentences.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TagCollectionViewCell
            cell.label.text = selectedTags[indexPath.row]
            cell.backgroundColor = .lightGray
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SentenceCollectionViewCell
            cell.bodyTextView.text = sentences[indexPath.row].text
            cell.sourceLabel.text = sentences[indexPath.row].source
            cell.backgroundColor = .lightGray
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagsCollectionView {
            var width: CGFloat = 80
            let tag = selectedTags[indexPath.row]
            width = estimateFrameForText(text: tag).width + 30
            return CGSize(width: width, height: 30)
        } else {
            var height: CGFloat = 80
            let text = sentences[indexPath.row].text
            height = estimateFrameForText(text: text).height + 40
            return CGSize(width: self.view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            if selectedTags.count == 1 {
                selectedTags.remove(at: indexPath.row)
                animate()
            } else {
                selectedTags.remove(at: indexPath.row)
                UIView.animate(withDuration: 0.3) {
                    self.tagsCollectionView.reloadData()
                    let height : CGFloat = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.tagsCollectionViewHeightConstraint?.constant = height
                    self.view.layoutIfNeeded()
                }
            }
            sentences = Warehouse.sharedInstance().getSentences(withHashtags: selectedTags)
        } else {
            delegate?.didTap(self, didSelect: sentences[indexPath.row])
        }
       reloadDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    fileprivate func animate() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tagsCollectionView.reloadData()
            let height : CGFloat = (self?.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height)!
            self?.tagsCollectionViewHeightConstraint?.constant = height
            self?.searchBarWidthConstraint?.constant = (self?.view.frame.width)!
            self?.goButton.alpha = 0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func reloadDataSource() {
        suggestionsTableView.reloadData()
        sentencesCollectionView.reloadData()
    }

    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 256, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 11)], context: nil)
        
    }
 
}

protocol ExpandedFirstPageViewControllerDelegate : class {
    func didTap(_ controller: ExpandedFirstPageViewController, didSelect sentence: Sentence)
}
