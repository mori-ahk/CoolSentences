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
    private var sentences : [Sentence]?
    private var suggestions = Array(Warehouse.sharedInstance().hashtags)
    private var filteredResult : [String]?
    private var selectedTags = [String]()
    private var collectionViewHeightConstraint : NSLayoutConstraint?
    private var tableViewHeightConstraint : NSLayoutConstraint?
    
    var searchController : UISearchController! {
        didSet {
            searchController.view.backgroundColor = .clear
            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchController.searchBar.backgroundColor = .red
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let rect = CGRect(x: 0, y: self.searchController.searchBar.frame.height, width: self.view.frame.width, height: 10)
        let cv = UICollectionView(frame: rect, collectionViewLayout: layout)
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    

    @IBOutlet weak var suggestionsTableView: UITableView! {
        didSet {
            suggestionsTableView.delegate = self
            suggestionsTableView.dataSource = self
            suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeSearchController()
        self.view.addSubview(searchController.searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(suggestionsTableView)
 
        tableViewHeightConstraint = suggestionsTableView.heightAnchor.constraint(equalToConstant: 500)
        NSLayoutConstraint.activate([
            suggestionsTableView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 4),
            suggestionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            suggestionsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            suggestionsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableViewHeightConstraint ?? NSLayoutConstraint()
            ])
        
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchController.searchBar.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor),
            searchController.searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchController.searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchController.searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchController.searchBar.widthAnchor.constraint(equalToConstant: self.view.frame.width)
            ])
        
        collectionViewHeightConstraint =  collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.searchController.searchBar.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionViewHeightConstraint ?? NSLayoutConstraint()
            ])
//        self.definesPresentationContext = true
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
        if selectedTags.count == 0 {
            selectedTags.append(selectedTag ?? "")
            UIView.animate(withDuration: 0.7) {
                self.collectionViewHeightConstraint?.constant = 30
                self.view.layoutIfNeeded()
            }
            
        }
        if !selectedTags.contains(selectedTag ?? "") {
            selectedTags.append(selectedTag ?? "")
            UIView.animate(withDuration: 0.7) {
                let height : CGFloat = self.collectionView.collectionViewLayout.collectionViewContentSize.height
                self.collectionViewHeightConstraint?.constant = height
                self.view.layoutIfNeeded()
                
            }
        }
        self.collectionView.reloadData()
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
        searchController.searchBar.backgroundColor = .white
    }
    
    
    //MARK: Search Bar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.layoutIfNeeded()
//        suggestionsTableView.reloadData()
//        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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
        return selectedTags.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TagCollectionViewCell
        cell.textView.text = "#\(selectedTags[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 80
        let tag = selectedTags[indexPath.row]
        width = estimateFrameForText(text: tag).width + 20
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 256, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], context: nil)
        
    }
}
