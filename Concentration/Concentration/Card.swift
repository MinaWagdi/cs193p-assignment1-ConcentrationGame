//
//  Card.swift
//  Concentration
//
//  Created by Mina Wagdi  on 2/17/19.
//  Copyright © 2019 Mina Wagdi . All rights reserved.
//

import Foundation

/* What is a struct?
 A struct  is the same as class, but there is 2 major differences :
 1- no inheritance
 2- struct are copy types, and classes are reference types.
 Int, dictioanries, etc.. are all structs
 */

struct Card: Hashable
{
    var hashValue:Int {return identifier}

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier==rhs.identifier
    }
    
    var isFaceUp=false
    var isMatched = false
    private var identifier : Int
    static var identifierFactory=0
    var WasPreviouslySeen = false
    //this Card struct should not have an emoji or jpeg that is on the card, because this is the model, it doesn;t have anything related to the View
    static func getUniqueIdentifier() -> Int{
        identifierFactory+=1
        return identifierFactory
        
    }
    static func resetCard(){
        identifierFactory=0
    }
    
    // init have the external and internal names for arguments the same
    init(){
        //print("Identifier Factory is \(Card.identifierFactory)")
        self.identifier=Card.getUniqueIdentifier()
    }
    
}
