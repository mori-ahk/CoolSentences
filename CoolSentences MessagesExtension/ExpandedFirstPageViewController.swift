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
    var searchController : UISearchController!
    
    @IBOutlet weak var suggestionsTableView: UITableView! {
        didSet {
            suggestionsTableView.delegate = self
            suggestionsTableView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeSearchController()
        self.definesPresentationContext = true
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
        var tags : [String]?
        let selectedTag = isFiltering() ? filteredResult?[indexPath.row] : suggestions[indexPath.row]
        tags?.append(selectedTag ?? "")
        sentences = Warehouse.sharedInstance().getSentences(withHashtags: tags ?? [])
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
        suggestionsTableView.tableHeaderView = searchController.searchBar
    }
    
    
    //MARK: Search Bar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        suggestionsTableView.reloadData()
        searchController.searchBar.showsCancelButton = true
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
            return $0.contains(queryString)
        })
    }

    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
