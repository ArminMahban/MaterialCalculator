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

//    @IBOutlet weak var one: MKButton!
    
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var delButton: MKButton!
    
    @IBOutlet var buttons: [MKButton]!
    
    @IBOutlet var operators: [MKButton]!
    
    @IBOutlet var topRowOperators: [MKButton]!
    
    
    @IBAction func digitPressed(sender: AnyObject) {
        let digit = sender.currentTitle as String!
        expressionLabel.text! += digit
        
        evaluteString(expressionLabel.text!)
        
    }
    
    @IBAction func equalPressed(sender: AnyObject) {
        expressionLabel.text = ""
    }
    
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
    
    func delLongPress() {
        
        expressionLabel.text = ""
        resultLabel.text = "0"
        
    }
    
    func evaluteString(numericExpression: String){
        if (numericExpression.characters.last >= "0" && numericExpression.characters.last <= "9") || numericExpression.characters.last == ")"{
            do {
                let result = try numericExpression.evaluate()
                if String(result).hasSuffix(".0") {
                    resultLabel.text = String(Int(result))
                }
                else{
                    resultLabel.text = String(result)
                }
            } catch _ {
                resultLabel.text = "Error"
                print("error in calculation")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MaterialColor.grey.darken3
        expressionLabel.text! = ""
        resultLabel.text! = "0"
        
        for button in buttons {
            button.backgroundLayerColor = UIColor.clearColor()
            button.rippleLocation = .Center
            button.rippleAniDuration = 0.5
        }
        
        for button in topRowOperators {
            
            button.tintColor = MaterialColor.lime.base
            
        }
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: "delLongPress")
        delButton.addGestureRecognizer(longGesture)
        
        delButton.cornerRadius = 25.0
        delButton.backgroundLayerCornerRadius = 25.0
        delButton.maskEnabled = false
        delButton.ripplePercent = 1.75
        delButton.rippleLocation = .Center
        delButton.layer.shadowOpacity = 0.75
        delButton.layer.shadowRadius = 2.0
        delButton.layer.shadowColor = UIColor.blackColor().CGColor
        delButton.layer.backgroundColor = MaterialColor.lime.base.CGColor
        delButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)

        let materialLayer: MaterialLayer = MaterialLayer(frame: CGRectMake(0, 0, self.view.bounds.width, 144))
        materialLayer.backgroundColor = MaterialColor.cyan.base.CGColor
        
        materialLayer.depth = .Depth5
        view.layer.insertSublayer(materialLayer, atIndex: 0)

    }

}

