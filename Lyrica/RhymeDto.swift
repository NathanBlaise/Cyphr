//
//  RhymeDto.swift
//  
//
//  Created by Nathan Lewis on 7/12/17.
//
//

import Foundation
import Gloss

class RhymeDto: Glossy{
    var word: String?
    var score: Int?
    var syllables: Int?
    
    required init?(json: JSON) {
        self.word = "word" <~~ json
        self.score = "score" <~~ json
        self.syllables = "numSyllables" <~~ json
    }
    
    init(word: String?, score: Int?, syllables: Int?){
        self.word = word
        self.score = score
        self.syllables = syllables
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "word" ~~> self.word,
            "score" ~~> self.score,
            "syllables" ~~> self.syllables
            ])
    }
    
}
