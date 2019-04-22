//
//  File.swift
//  Concentration
//
//  Created by Mina Wagdi  on 2/17/19.
//  Copyright © 2019 Mina Wagdi . All rights reserved.
//

import Foundation

struct Concentration
{
    var cards=Array<Card>()
    var score = 0
    var flipCount = 0
    
    //We made it optional because if no cards are faceUp or if two cards are FaceUp, it will have no value.
    var indexOfOneAndOnlyCardFaceUp:Int?
    
    mutating func chooseCard(at index:Int){
        // if it's not matched, don't do anything (Note: it's a flipCount, but nothing is happening)
        if !cards[index].isMatched{
            
            // IN the next line, we check if we already have one faceUp card and if yes we compare the index of the one and only faceUp card with the index of the current choice of cards to see if they are the same (If they are the same that means I have clicked on the same faceUp card twice, if they are not the same enter in this if condition)
            if let matchIndex = indexOfOneAndOnlyCardFaceUp, matchIndex != index{
                //Only one card is faceUp and i have just clicked on another card so I check if cards match
                if cards[matchIndex]==cards[index]{
                    cards[matchIndex].isMatched=true
                    cards[index].isMatched=true
                    score+=2
                }
                else{
                    if cards[index].WasPreviouslySeen{
                        score-=1
                    }
                }
                cards[index].isFaceUp=true
                indexOfOneAndOnlyCardFaceUp=nil
                
            }
                //Here, either we already have 2 faceUp cards or we have clicked on the same faceUp card twice, the clicked card will be faceUp (even if it's the same card that's already faceUp)
            else{
                //either two cards or no cards are faceUp
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp=false
                }
                cards[index].isFaceUp=true
                indexOfOneAndOnlyCardFaceUp=index
                
            }
            cards[index].WasPreviouslySeen=true
            
        }
//        if cards[index].isFaceUp{
//            cards[index].isFaceUp=false
//        }else{
//            cards[index].isFaceUp=true
//        }
        
    }
    
    init(numberOfPairsOfCards:Int){
        //print("numberofPairOfCards is \(numberOfPairsOfCards)")
        //up to numberOfPaisOfCards (but not including)
        // there is another kind of for loops 0...number, loop from 0 to and including "number"
        // underscore means ignore it
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
//            let matchingCard = Card(identifier: identifier)
            let matchingCard = card //it makes a copy not a reference since it's a struct
            // Since Card is a struct --> Value type not reference type, so both card and matching card will have the same identifier.
//            let matchingCard = Card()
            cards.append(card)
            cards.append(matchingCard)
//            cards+=[card,card]
        }
        // TODO : SHUFFLE THE CARDS
        cards.shuffle()
    }
    mutating func resetConcentration(){
        cards.removeAll()
        indexOfOneAndOnlyCardFaceUp=nil
        score = 0
        flipCount = 0
    }
    
}
