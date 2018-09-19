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
    private init() {
        updateModel()
    }
    
    var sentences = [Sentence]()
    var hashtags = Set<String>()
    
    private func updateModel() {
        readFile()
        updateHashtags()
    }
    
    private func readFile() {
        
        if let filepath = Bundle.main.path(forResource: "data", ofType: "txt") {
          
            do {
                let contents = try String(contentsOfFile: filepath)
                let allSentences = contents.components(separatedBy: .newlines)
                fillSentencesArray(from: allSentences)
            } catch {
                print(error)
                return
            }
        }
    }
    
    private func fillSentencesArray(from lines: [String]) {
        var sentenceObject: Sentence?
        for i in 0...(lines.count - 1) {
            switch (i % 5) {
            case 0:
                sentenceObject = Sentence()
            case 1:
                sentenceObject!.text = lines[i]
            case 2:
                sentenceObject!.initTags(lines[i])
            case 3:
                sentenceObject!.source = lines[i]
            case 4:
                sentences.append(sentenceObject!)
            default:
                print("error")
            }
        }
    }
    
    private func updateHashtags() {
        sentences.forEach { (sentence) in
            sentence.tags.forEach({hashtags.insert($0)})
        }
    }
    
    func getSentences( withHashtags tags: [String]) -> [Sentence] {
        if tags.count == 0 {
            return []
        }
        var editedTags: [String] = []
        tags.forEach({editedTags.append(String($0.dropFirst()))})
        return sentences.filter {canFind(editedTags, in: $0.tags)}
    }
    
    private func canFind(_ tags: [String], in sentenceTags: [String]) -> Bool {
        for i in 0 ..< tags.count {
            if (!sentenceTags.contains(tags[i])) {
                return false
            }
        }
        return true
    }
}
