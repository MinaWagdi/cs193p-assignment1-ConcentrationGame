//
//  ViewController.swift
//  Concentration
//
//  Created by Mina Wagdi  on 2/15/19.
//  Copyright © 2019 Mina Wagdi . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // We have should be using an initializer (I think it's like a constructor)
    
    //classes (and concentration is a class) get a free init so we can use it. But with condition that all variables are initialized--> So we created init for the other classes
    //var game = Concentration()
    //lazy--> didn't understand it well
    //lazy doesn't have a didSet
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var numberOfPairsOfCards:Int{
        get{
            return (cardButtons.count+1)/2
        }
    }
    
    //  there is something called property observer, so every time the property's value changes, something happens (as shown in "didSet")
//    private(set) var flipCount = 0{
//        didSet{
//           updateFlipCountLabel()
//
//        }
//    }
    
    func updateLabels(){
        let attributes : [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.orange
        ]
        print("Flip Count initially is \(game.flipCount)")
        print("Score initially is \(game.score)")
        let flibCountLabelAttributedString = NSAttributedString(string: "Flips:\(game.flipCount)", attributes: attributes)
        let scoreLabelAttributedString = NSAttributedString(string: "Score:\(game.score)", attributes: attributes)
        //            flipCountLabel.text="Flips:\(flipCount)"
        flipCountLabel.attributedText=flibCountLabelAttributedString
        ScoreLabel.attributedText=scoreLabelAttributedString
    }
    
    //outlet ---> is for instance variables (properties)
    @IBOutlet private weak var flipCountLabel: UILabel!
//    {
//        didSet{
//            updateLabels()
//        }
//    }
    
    @IBOutlet weak var ScoreLabel: UILabel!
//    {
//        didSet{
//            updateLabels()
//        }
//    }
    //to save the button instances in it (The button instances represent the cards)
    //Not an outlet, not an action, it's an outletCollection
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction func StartNewGame(_ sender: UIButton) {
        endGame()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        game.flipCount+=1
        // the method firstIndex return Int? (called Optional) not an Int
        //Optional data types has two states " set and not set
        //So the method here returns "set" or returns "not set", if "set" is returned, it returns along with it an Int (They are like data that goes along with the varriable, associated with it)
        //If I put an excalamation mark at the end, it means assume it return a state "set" and extract the package with it. If accidentally it's not set, it will crach the app
        // To avoid crashing the app, put "if let" instead of let
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else{
            print("Chosen card is not in the cardButtons array")
        }
    }
    
    // the caller uses the external name of the arguments, but within the function, we use the internal name
    
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for :UIControl.State.normal)
                //if it's matched and face down, we make it clear
                button.backgroundColor=card.isMatched ? #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 0) : CardBackColor
            }
        }
        updateLabels()
    }
    
//   private var halloweenEmoji:Array<String>=["👻","🎃","😨","😼","👺","🍭","👾","😈","🤡","🤮","☠️","💩"]
    
//    var facesEmoji:Array<String>=["","","",""]
    
//    var emoji=Dictionary<Int,String>()
    var emoji = [Card:String]()
    var ThemeEmojiArray:String=""
    var BackgroundColor=UIColor()
    var CardBackColor=UIColor()
    
    func emoji(for card: Card)->String{
        print("getting an emoji from ThemeEmojiArray is \(ThemeEmojiArray)")
        if emoji[card]==nil{
            //print("NEW IDENTIFIER THAT DOESN'T HAVE AN EMOJI \(card.identifier)")
            if(ThemeEmojiArray.count>0){
                let randomIndex = Int(arc4random_uniform(UInt32(ThemeEmojiArray.count)))
                let randomStringIndex = ThemeEmojiArray.index(ThemeEmojiArray.startIndex, offsetBy:randomIndex)
                //We remove the emoji from the emoji choices in order not to get two identifiers (two pair of cards ) with the same emoji
                emoji[card]=String(ThemeEmojiArray.remove(at: randomStringIndex))
            }
        }
//        if let chosenEmoji=emoji[card.identifier]{
//            return emoji[card.identifier]!
//        }else{
//            return "?"
//        }
//        print("returning card identifier \(card.identifier) ")
        return emoji[card] ?? "?" // this  code is exactly the same as the one before commented
    }
    func endGame(){
        game.resetConcentration()
        Card.resetCard()
        resetController()
        game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
        
        let randomTheme=Theme.getRandomTheme()
        ThemeEmojiArray = randomTheme.getThemeEmojiArray()
        emoji = [Card:String]()
        print("ThemeEmojiArray is \(ThemeEmojiArray)")
        BackgroundColor = randomTheme.getBackgroundColor()
        self.view.backgroundColor=BackgroundColor
        CardBackColor = randomTheme.getCardBackColor()
        
        updateViewFromModel()
    }
    func resetController(){
        for index in cardButtons.indices{
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor=CardBackColor
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomTheme=Theme.getRandomTheme()
        ThemeEmojiArray = randomTheme.getThemeEmojiArray()
        print("ThemeEmojiArray is \(ThemeEmojiArray)")
        BackgroundColor = randomTheme.getBackgroundColor()
        self.view.backgroundColor=BackgroundColor
        CardBackColor=randomTheme.getCardBackColor()
        updateViewFromModel()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

/*
 Model View Controller--> three camps
 Model Camp --> "What", UI independent, the part of the app that knows how to play the Concentration game, What your application is (But not how it's displayed)
 Controller Camp --> How your concentration game appears on screen (UI Logic) How the model is presented to the user
 View Camp -->Generic minions of the Controller
 
 Controller can Communicate with Model
 Controller can Communicate with View.
 Model and View cannot communicate directly.
 View can communicate directly with the Contoller but in a structured way, We used one of this type of communications, when we created an action method for the button (touchCard through control and drag to the code).
 */

enum Theme: String{
    case Sports
    case Halloween
    case Food
    case faces
    
    static func getRandomTheme()->Theme{
        let ThemeRandom = [Theme.Sports,Theme.Halloween,Theme.Food,Theme.faces]
        let index = Int(arc4random_uniform(UInt32(ThemeRandom.count)))
        let theme = ThemeRandom[index].rawValue
        return Theme(rawValue: theme)!
    }
    
    func getThemeEmojiArray()->String{
        switch self{
        case .Sports: return "🏀🏈🏉🏏🏐⚽️⛳️🏓🏄‍♀️🚵‍♀️🏃🏼‍♀️🏆🥇🥈🎖🥉🏑🎾🏸🎱🎳🎽🥋⛸🏹🛹🥏"
        case .Halloween: return "👻🎃😨😼👺🍭👾😈🤡🤮☠️💩🥶👹🦖🦎🐍🐢🐙🦕❌🔱⚜️℥Ω🍖🍗🦍"
        case .Food: return "🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🥭🍍🥥🥝🍅🍆🥑🥦🥬🥒🌶🌽🥕🥔🍠🥐🥯🍞🥖🥨🧀🥚🍳🥞🥓🥩🍗"
        case .faces: return "😀😃😄😁😆😅😂🤣☺️😊😇🙂🙃😉😌😍🥰😘😗🥳🤩😎🤓☹️😣😖😡🤬🤯😳🥵🥶🤕🤐🥴🤠"
        }
    }
    func getBackgroundColor()->UIColor{
        switch self{
        case .Sports: return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case .Halloween: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .Food: return #colorLiteral(red: 0.6655879021, green: 1, blue: 0.9884930253, alpha: 1)
        case .faces: return #colorLiteral(red: 1, green: 0.9866651893, blue: 0, alpha: 1)
        }
    }
    
    func getCardBackColor()->UIColor{
        switch self{
        case .Sports: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .Halloween: return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case .Food: return #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        case .faces: return #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        }
    }
    
}




