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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    private func presentViewController(with presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()
        
        let controller: UIViewController
        if presentationStyle == .compact {
            controller = instantiateCompactFirstController()
            
        } else {
            controller = instantiateExpandedFirstController()
        }
        
        addChildViewController(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    
    private func instantiateCompactFirstController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CompactFirstPageViewController.storyboardIdentifier)
            as? CompactFirstPageViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        return controller
    }
    
    private func instantiateExpandedFirstController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ExpandedFirstPageViewController.storyboardIdentifier)
            as? ExpandedFirstPageViewController
            else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
        
        return controller
    }
    
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - Conversation Handling
    
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentViewController(with: presentationStyle)
 
    }
    
    override func didResignActive(with conversation: MSConversation) {

    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {

    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {

    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()

    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        presentViewController(with: presentationStyle)
 
    }
    
}


