//
//  MessagesViewController.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-05.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    private let array = ["funny", "hello", "birthday", "jokes", "pickuplines"]
    
    private lazy var tagsField : WSTagsField = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 40)
        let field = WSTagsField(frame: rect)
        field.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        field.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        field.spaceBetweenLines = 4.0
        field.spaceBetweenTags = 10.0
        field.font = .systemFont(ofSize: 15.0)
        field.backgroundColor = .lightGray
        field.layer.cornerRadius = 20
        field.cornerRadius = 10
        field.borderColor = .red
        field.tintColor = .black
        field.textColor = .white
        field.fieldTextColor = .black
        field.selectedColor = .yellow
        field.selectedTextColor = .black
        field.delimiter = ""
        field.isDelimiterVisible = true
        field.placeholderColor = .black
        field.placeholderAlwaysVisible = true
        field.returnKeyType = .next
        field.acceptTagOption = .space
        field.isHidden = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var tagsTableView : UITableView = {
        let tableViewWidth : CGFloat = self.view.frame.width
        let tableViewHeight : CGFloat = self.view.frame.height
        let rect = CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight)
        let tableView = UITableView(frame: rect)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var tableViewHeader : UIView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let view = UIView(frame: rect)
        view.backgroundColor = .clear
        return view
    }()
    
    private let suggestionsLabel : UILabel = {
        let label = UILabel()
        label.text = "Suggestions"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goButton : UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.isHidden = true
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let swipeUpLabel : UILabel = {
        let label = UILabel()
        label.text = "Swipe UP! 😊👆🏽"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.alpha = 0.8
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tagsField)
        self.view.addSubview(tagsTableView)
        self.view.addSubview(swipeUpLabel)
        self.view.addSubview(goButton)
        tableViewHeader.addSubview(suggestionsLabel)
        
        //MARK: - Layout Constraint
        NSLayoutConstraint.activate([
            tagsField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12),
            tagsField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            tagsTableView.topAnchor.constraint(equalTo: self.tagsField.bottomAnchor, constant: 8),
            tagsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tagsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tagsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            suggestionsLabel.topAnchor.constraint(equalTo: self.tableViewHeader.topAnchor),
            suggestionsLabel.rightAnchor.constraint(equalTo: self.tableViewHeader.rightAnchor, constant: 12),
            suggestionsLabel.leftAnchor.constraint(equalTo: self.tableViewHeader.leftAnchor, constant: 12),
            suggestionsLabel.bottomAnchor.constraint(equalTo: self.tableViewHeader.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            swipeUpLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            swipeUpLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
            ])
        
        NSLayoutConstraint.activate([
            goButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12),
            goButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -2),
            goButton.leftAnchor.constraint(equalTo: self.tagsField.rightAnchor, constant: 4),
            goButton.heightAnchor.constraint(equalTo: tagsField.heightAnchor),
            goButton.centerYAnchor.constraint(equalTo: tagsField.centerYAnchor)
            ])
        
        tagsField.onDidChangeHeightTo = { (_,_) in
            self.view.layoutIfNeeded()
        }
        Warehouse.sharedInstance().updateModel()
        goButton.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }
    
    @objc func onButtonClicked() {
        UIView.animate(withDuration: 0.5) {
            self.tagsTableView.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Conversation Handling
    
    
    override func willBecomeActive(with conversation: MSConversation) {
        
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        
        
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .compact {
            tagsTableView.isHidden = true
            tagsField.isHidden = true
            swipeUpLabel.isHidden = false
            goButton.isHidden = true
            tagsField.removeTags()
        } else {
            tagsTableView.isHidden = false
            tagsField.isHidden = false
            swipeUpLabel.isHidden = true
            goButton.isHidden = false
        }
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
}

extension MessagesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(array[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagsField.addTag(array[indexPath.row])

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.tableViewHeader : nil
    }
    
    
}
