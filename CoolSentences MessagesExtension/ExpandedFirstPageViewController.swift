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
    private let suggestionCellIdentifier = "suggestionCell"
    private let tagCellIdentifier = "tagCell"
    private let sentencesCellIdentifier = "sentencesCell"
    private var sentences = [Sentence]()
    private var suggestions = Array(Warehouse.sharedInstance().hashtags)
    private var filteredResult: [String]?
    private var selectedTags = [String]()
    private var tagsCollectionViewHeightConstraint : NSLayoutConstraint?
    private var searchBarWidthConstraint: NSLayoutConstraint?
    private var sentenceCollectionViewTopAnchor: NSLayoutConstraint?
    private var isUserEditingSearchField: Bool?

    weak var delegate: ExpandedFirstPageViewControllerDelegate?
    
    var searchController: UISearchController! {
        didSet {
            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellIdentifier)
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
        CV.register(SentenceCollectionViewCell.self, forCellWithReuseIdentifier: sentencesCellIdentifier)
        CV.delegate = self
        CV.dataSource = self
        CV.backgroundColor = .white
        CV.isHidden = true
        CV.translatesAutoresizingMaskIntoConstraints = false
        return CV
    }()
    
    let goButton: UIButton = {
       let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0.05303675681, green: 0.5231412649, blue: 0.9969810843, alpha: 1)
        button.isHidden = false
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onGoButton), for: .touchUpInside)
        return button
    }()
    
    @objc func onGoButton() {
        //TODO: Refactor this part
        sentences = Warehouse.sharedInstance().getSentences(withHashtags: selectedTags)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.suggestionsTableView.alpha = 0
            self.sentencesCollectionView.alpha = 1
            self.searchBarWidthConstraint?.constant = self.view.frame.width
        }
        sentencesCollectionView.isHidden = false
        tagsCollectionView.isHidden = true
        sentencesCollectionView.reloadData()
    }
    
    @IBOutlet weak var suggestionsTableView: UITableView! {
        didSet {
            suggestionsTableView.delegate = self
            suggestionsTableView.dataSource = self
            suggestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupViews() {
        view.addSubview(searchController.searchBar)
        view.addSubview(tagsCollectionView)
        view.addSubview(suggestionsTableView)
        view.addSubview(sentencesCollectionView)
        view.addSubview(goButton)
        
        searchBarWidthConstraint = searchController.searchBar.widthAnchor.constraint(equalToConstant: view.frame.width)
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarWidthConstraint ?? NSLayoutConstraint(),
            searchController.searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchController.searchBar.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        tagsCollectionViewHeightConstraint = tagsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: searchController.searchBar.frame.height - 5),
            tagsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tagsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tagsCollectionViewHeightConstraint ?? NSLayoutConstraint()
            ])
        
        NSLayoutConstraint.activate([
            suggestionsTableView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 2),
            suggestionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            suggestionsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            ])
        
        NSLayoutConstraint.activate([
            goButton.topAnchor.constraint(equalTo: view.topAnchor),
            goButton.leftAnchor.constraint(equalTo: searchController.searchBar.rightAnchor),
            goButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2),
            goButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        NSLayoutConstraint.activate([
            sentencesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: searchController.searchBar.frame.height - 5),
            sentencesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sentencesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sentencesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCellIdentifier , for: indexPath)
        cell.textLabel?.text = isFiltering() ? "\(filteredResult?[indexPath.row] ?? "")" : "\(suggestions[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTag = isFiltering() ? filteredResult?[indexPath.row] : suggestions[indexPath.row]
        if selectedTags.contains(selectedTag ?? "") == false {
            selectedTags.append("\(selectedTag ?? "")")
            //TODO: Refactor this part
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.tagsCollectionView.reloadData()
                let height: CGFloat = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.tagsCollectionViewHeightConstraint?.constant = height
                if self.isUserEditingSearchField ?? false {
                    self.searchBarWidthConstraint?.constant = self.view.frame.width
                } else {
                    self.searchBarWidthConstraint?.constant = self.view.frame.width - 70
                }
                self.goButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Suggestions" : ""
    }
}

extension ExpandedFirstPageViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
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
        definesPresentationContext = true
    }

    //MARK: Search Bar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //TODO: Refactor this part
        isUserEditingSearchField = true
        goButton.isHidden = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.suggestionsTableView.alpha = 1
            self?.sentencesCollectionView.alpha = 0
        }
        searchBarWidthConstraint?.constant = view.frame.width
        tagsCollectionView.isHidden = false
        searchController.searchBar.showsCancelButton = false
        suggestionsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarWidthConstraint?.constant = selectedTags.count == 0 ? view.frame.width : view.frame.width - 70
        isUserEditingSearchField = false
        goButton.isHidden = false
        suggestionsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isFiltering() == false {
            suggestionsTableView.reloadData()
        }
        searchController.searchBar.showsCancelButton = true
        onGoButton()
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
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
        return searchController.isActive && searchBarIsEmpty() == false
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as! TagCollectionViewCell
            cell.label.text = "#\(selectedTags[indexPath.row])"
            cell.backgroundColor = #colorLiteral(red: 0.05303675681, green: 0.5231412649, blue: 0.9969810843, alpha: 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sentencesCellIdentifier, for: indexPath) as! SentenceCollectionViewCell
            let sentence = sentences[indexPath.row]
            cell.renderCell(from: sentence)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagsCollectionView {
            var width: CGFloat = 80
            let tag = "#\(selectedTags[indexPath.row])"
            width = estimateFrameForText(text: tag, fontSize: 12).width + 30
            return CGSize(width: width, height: 30)
        } else {
            var height: CGFloat = 80
            let text = sentences[indexPath.row].text
            height = estimateFrameForText(text: text, fontSize: 14).height + 70
            return CGSize(width: view.frame.width - 10, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            if selectedTags.count == 1 {
                selectedTags.remove(at: indexPath.row)
                animate()
            } else {
                selectedTags.remove(at: indexPath.row)
                //TODO: Refactor this part
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.tagsCollectionView.reloadData()
                    let height: CGFloat = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
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
            guard let self = self else { return }
            self.tagsCollectionView.reloadData()
            let height: CGFloat = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.tagsCollectionViewHeightConstraint?.constant = height
            self.searchBarWidthConstraint?.constant = self.view.frame.width
            self.goButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func reloadDataSource() {
        suggestionsTableView.reloadData()
        sentencesCollectionView.reloadData()
    }

    private func estimateFrameForText(text: String, fontSize: CGFloat) -> CGRect {
        let size = CGSize(width: 256, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes =  [NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}

protocol ExpandedFirstPageViewControllerDelegate: class {
    func didTap(_ controller: ExpandedFirstPageViewController, didSelect sentence: Sentence)
}
