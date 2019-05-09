//
//  ViewController.swift
//  Concentration
//
//  Created by Genevieve Patterson on 4/27/19.
//  Copyright © 2019 Genevieve Patterson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2  
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    private(set) var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction func startNewGame(_ sender: Any) {
        // randomly select new theme
        theme = Array(emojiChoices.keys).randomElement()!
        emojiChoicesForCurrentGame = emojiChoices[theme]!
        
        // make a new game
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        
        // update view to show new game
        updateViewFromModel()
        
        // reset flipCount and scoreCount
        flipCount = 0
        scoreCount = 0  
        
        // reset dictionary storing current emoji to card index map
        emoji = [Card: String]()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount = game.flipCount
        scoreCount = game.currentScore
        let cardNumber = cardButtons.firstIndex(of: sender)!
//        flipCard(withEmoji: emojiChoices[cardNumber], on: sender )
        
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        
    }
    
    private var emojiChoices = ["halloween": "👻🎃😸😈☠️🧛🏽‍♀️🦹🏾‍♀️🕷🦇" ,
                                "animals": "🐯🐹🦊🐻🐼🐨",
                                "plants": "🌵🌳🌲🍄🌷🌺🌸",
                                "ocean": "🐳🦑🐠🦀🐡🦈🐙",
                                "space": "🌖🌎💫💥☄️🌞",
                                "food": "🍎🥑🍕🥘🍝🍙🍩"]
    
    private var theme = "animals"
    private lazy var emojiChoicesForCurrentGame = emojiChoices[theme]!
    
    private var emoji = [Card: String]()
    
    // MARK: Handle Emoji Selection
    private func emoji(for card: Card) -> String {

        
        if emoji[card] == nil, emojiChoicesForCurrentGame.count > 0 {
            
            let randomStringIndex = emojiChoicesForCurrentGame.index(emojiChoicesForCurrentGame.startIndex, offsetBy:  emojiChoicesForCurrentGame.count.arc4random)
            emoji[card] = String(emojiChoicesForCurrentGame.remove(at: randomStringIndex))
            print("Card \(card): \(emoji[card]!) choices left = \(emojiChoicesForCurrentGame.count)")
        }
        return emoji[card] ?? "?"
    }


}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
