//
//  ViewController.swift
//  Calculator
//
//  Created by ArminM on 1/30/16.
//  Copyright © 2016 ArminM. All rights reserved.
//

import UIKit
import Material
import MaterialKit
import MathParser

class ViewController: UIViewController {

    
    @IBOutlet weak var expressionLabel: UILabel!  //Top label that holds the math
    @IBOutlet weak var resultLabel: UILabel!      //Label the holds the result of the expression label
    @IBOutlet weak var delButton: MKButton!
    @IBOutlet weak var exponentButton: MKButton!
    @IBOutlet var buttons: [MKButton]!            //Array of all buttons
    @IBAction func menuPressed(sender: AnyObject) {
        sideNavigationViewController?.open()
    }
    
    @IBAction func exponentPressed(sender: AnyObject) {
        exponentActive = !exponentActive
    }
    
    //has the exponent button been pressed?
    var exponentActive = false
    
    //Used to easily add commas to a result label
    let numberFormatter = NSNumberFormatter()
    
    //Colorful top layer
    let materialLayer = MaterialLayer()
    
    let colorArr: [UIColor] = [MaterialColor.cyan.base, MaterialColor.red.base, MaterialColor.green.base, MaterialColor.deepPurple.base, MaterialColor.indigo.base, MaterialColor.orange.base]
    let secondaryColorArr: [UIColor] = [MaterialColor.red.lighten1, MaterialColor.indigo.base, MaterialColor.brown.lighten1, MaterialColor.pink.base, MaterialColor.deepOrange.base]
    
    //variables to store the active primary and secondary colors
    var mainColor = UIColor()
    var secondaryColor = UIColor()
    
    
    @IBAction func digitPressed(sender: AnyObject) {
        let digit = sender.currentTitle as String!
        if exponentActive {
            //retrieve the proper exponent based on the number pressed
            expressionLabel.text! += expon(digit)
            exponentActive = false
        } else {
            //append the digit pressed
            expressionLabel.text! += digit

        }
        //evaluate the string after every press
        evaluteString(expressionLabel.text!)
    }
    
    
    /**

     When the equal button is pressed, set the approrpriate output (Error if necessary),
     and save the results into history through NSUserDefaults. Next, call the side navigation
     which holds the history to update and finally reset the expression label.
     
    */
    @IBAction func equalPressed(sender: AnyObject) {
        exponentActive = false
        if resultLabel.text == "..." {
            resultLabel.text = "Error"
        } else {
            if NSUserDefaults.standardUserDefaults().objectForKey("expressionArr") == nil {
                var expressionArr = [String]()
                expressionArr.append(expressionLabel.text!)
                var resultsArr = [String]()
                resultsArr.append(resultLabel.text!)
                print("setting \(expressionArr)")
                NSUserDefaults.standardUserDefaults().setObject(expressionArr, forKey: "expressionArr")
                NSUserDefaults.standardUserDefaults().setObject(resultsArr, forKey: "resultsArr")
            } else {
                var expressionArr = NSUserDefaults.standardUserDefaults().objectForKey("expressionArr") as! [String]
                expressionArr.append(expressionLabel.text!)
                NSUserDefaults.standardUserDefaults().setObject(expressionArr, forKey: "expressionArr")
                var resultsArr = NSUserDefaults.standardUserDefaults().objectForKey("resultsArr") as! [String]
                resultsArr.append(resultLabel.text!)
                NSUserDefaults.standardUserDefaults().setObject(resultsArr, forKey: "resultsArr")
            }
            
            let sideNavVC = self.parentViewController?.childViewControllers[1] as! SideNavViewController
            sideNavVC.loadHistory()
        }
        expressionLabel.text = ""
    }
    
    //delete the last character and re-evaluate the expression
    @IBAction func delPressed(sender: AnyObject) {
        if expressionLabel.text?.characters.count > 1{
            expressionLabel.text = String(expressionLabel.text!.characters.dropLast())
            evaluteString(expressionLabel.text!)
        }
        else{
            expressionLabel.text = ""
            resultLabel.text = "0"
        }
    }
    
    //reset the expression when the delete button is held
    func delLongPress() {
        expressionLabel.text = ""
        resultLabel.text = "0"
    }
    
    /**
     
     Use the Math parser to evaluate the imputted string as an expression
     NSExpression is a native alternative but DDParser is a bit more
     flexible and has better error handling

    */
    func evaluteString(numericExpression: String){
        //check that the expression ends in a number, ')', or an exponent
        if (numericExpression.characters.last >= "0" && numericExpression.characters.last <= "9") || numericExpression.characters.last == ")" || exponentCharacters.contains(String(numericExpression.characters.last!)) {
            do {
                let result = try numericExpression.evaluate()
                //round result if necessary
                if String(result).hasSuffix(".0") {
                    let resultInt = Int(result)
                    resultLabel.text = numberFormatter.stringFromNumber(resultInt)!
                }
                else{
                    resultLabel.text = numberFormatter.stringFromNumber(result)!
                }
            //handle expressions that can't be evaluated
            } catch _ {
                resultLabel.text = "..."
            }
        }
    }
    
    //Used at startup
    func formatButtons() {
        for button in buttons {
            button.backgroundLayerColor = UIColor.clearColor()
            button.rippleLocation = .Center
            button.rippleLayerColor = mainColor
            button.rippleAniDuration = 0.5
        }
    }
    
    //Called from the side navigation to change the color them of the app
    func colorChanged(mainColor: UIColor, secondaryColor: UIColor) {
        delButton.layer.backgroundColor = secondaryColor.CGColor
        materialLayer.backgroundColor = mainColor.CGColor
        for button in buttons {
            button.rippleLayerColor = mainColor
        }
    }
    
    //format the initial view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MaterialColor.grey.darken3
        expressionLabel.text! = ""
        resultLabel.text! = "0"
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 10
        
        if NSUserDefaults.standardUserDefaults().objectForKey("color") == nil {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "color")
        }

        let colorArrInt = NSUserDefaults.standardUserDefaults().integerForKey("color")
        print(colorArrInt)
        mainColor = self.colorArr[colorArrInt]
        secondaryColor = self.secondaryColorArr[colorArrInt]

        formatButtons()
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: "delLongPress")
        delButton.addGestureRecognizer(longGesture)
        delButton.backgroundColor =  secondaryColor
        delButton.cornerRadius = 25.0
        delButton.backgroundLayerCornerRadius = 25.0
        delButton.maskEnabled = false
        delButton.ripplePercent = 1.75
        delButton.rippleLocation = .Center
        delButton.layer.shadowOpacity = 0.75
        delButton.layer.shadowRadius = 2.0
        delButton.layer.shadowColor = UIColor.blackColor().CGColor
        delButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        materialLayer.frame = CGRectMake(0, 0, view.bounds.width, 144)
        materialLayer.depth = .Depth5
        materialLayer.backgroundColor = mainColor.CGColor
        view.layer.insertSublayer(materialLayer, atIndex: 0)

    }

    //set used to check if character is an exponent
    let exponentCharacters: Set<String> = [
        "⁰","¹","²","³","⁴","⁵","⁶","⁷","⁸","⁹","⁺","⁻","⁽","⁾",
    ]
    
    //given a number return it's exponent unicode character if applicable
    func expon(last: String) -> String {
        
        switch last {
        case "1":
            return "\u{00B9}"
        case "2":
            return "\u{00B2}"
        case "3":
            return "\u{00B3}"
        case "4":
            return "\u{2074}"
        case "5":
            return "\u{2075}"
        case "6":
            return "\u{2076}"
        case "7":
            return "\u{2077}"
        case "8":
            return "\u{2078}"
        case "9":
            return "\u{2079}"
        case "0":
            return "⁰"
        case "(":
            return "⁽"
        case ")":
            return "⁾"
        case "+":
            return "⁺"
        case "-":
            return "⁻"
        default:
            return last
        }
    }

}

