//
//  Warehouse.swift
//  CoolSentences MessagesExtension
//
//  Created by Morteza Ahmadi on 2018-09-05.
//  Copyright © 2018 Morteza Ahmadi. All rights reserved.
//

import Foundation

class Warehouse {
    
    
    private static var shared: Warehouse = {
        return Warehouse.init()
    }()
    
    class func sharedInstance() -> Warehouse {
        return shared
    }
    private init() {}
    
    func readFile() {
        
        if let filepath = Bundle.main.path(forResource: "data", ofType: "txt") {
          
            do {
                let contents = try String(contentsOfFile: filepath)
                let allSentences = contents.components(separatedBy: .newlines)
                sentenceObject(from: allSentences)
            } catch {
                print(error)
                return
            }
        }
    }
    
    private func sentenceObject(from sentences: [String]) {
        var sentencesArray = [Sentence]()
        var text: String = ""
        var tags: String = ""
        var source: String = ""
        for i in 0...(sentences.count - 1) {
            if i % 5 == 1 {
                text = sentences[i]
            } else if i % 5 == 2 {
                tags = sentences[i]
            } else if i % 5 == 3 {
                source = sentences[i]
            }
            if i % 5 == 0 {
                let sentenceObject = Sentence.init(text: text, source: source, tags: tags)
                sentencesArray.append(sentenceObject)
            }
        }
    }
}
