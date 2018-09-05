//
//  Sentence.swift
//  CoolSentences MessagesExtension
//
//  Created by Yashar Dabiran on 2018-09-05.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import Foundation

class Sentence {
    var text: String
    var source: String
    var tags: [String] = []
    
    init(text: String, source: String, tags: String) {
        self.text = text
        self.source = source
        initTags(tags)
    }
    
    func initTags(_ tags: String) {
        let tagsWithHashtag = tags.split(separator: " ")
        tagsWithHashtag.forEach {
            self.tags.append(String($0.dropFirst()))
        }
    }
}
