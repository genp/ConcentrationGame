//
//  Concentration.swift
//  Concentration
//
//  Created by Genevieve Patterson on 5/1/19.
//  Copyright © 2019 Genevieve Patterson. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    
    private(set) var currentScore = 0
    private(set) var flipCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
            get {
                return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            }
            set {
                for index in cards.indices {
                    cards[index].isFaceUp = (index == newValue)
                }
            }
    }

    
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        flipCount += 1
        
        if !cards[index].isMatched
        
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards ma`tch
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    // Score the game by giving 2 points for every match
                    currentScore += 2
                } else {
                    // penalizing 1 point for every previously seen card that is involved in a mismatch.
                    currentScore -= 1
                }
                 cards[index].isFaceUp = true

            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }

        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)) must be greater than 0")
        for _ in 0..<numberOfPairsOfCards{
            let card =  Card()
            cards += [card, card]
        }
        // Shuffle the cards - Homework!
        cards.shuffle()
    }
}


extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
