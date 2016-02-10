//
//  SideNavViewController.swift
//  Calculator
//
//  Created by ArminM on 2/7/16.
//  Copyright © 2016 ArminM. All rights reserved.
//

import UIKit
import Material

class SideNavViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var historyTableView: UITableView!
    
    //clear the stored history and clear the table view
    @IBAction func clearPressed(sender: AnyObject) {
        let blankArr: [String] = []
        NSUserDefaults.standardUserDefaults().setObject(blankArr, forKey: "expressionArr")
        NSUserDefaults.standardUserDefaults().setObject(blankArr, forKey: "resultsArr")
        self.resultsArr.removeAll()
        self.expressionArr.removeAll()
        self.historyTableView.reloadData()
        
    }

    //Handle theme changes by calling the main view controller's function to change colors
    @IBAction func b1(sender: AnyObject) {
        let calcVC = self.parentViewController?.childViewControllers[0] as! ViewController
        calcVC.colorChanged(colorArr[0], secondaryColor: secondaryColorArr[0])
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "color")
        changeSideColors(0)
        
    }
    
    @IBAction func b2(sender: AnyObject) {
        let calcVC = self.parentViewController?.childViewControllers[0] as! ViewController
        calcVC.colorChanged(colorArr[1], secondaryColor: secondaryColorArr[1])
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "color")
        changeSideColors(1)

    }
    
    @IBAction func b3(sender: AnyObject) {
        let calcVC = self.parentViewController?.childViewControllers[0] as! ViewController
        calcVC.colorChanged(colorArr[2], secondaryColor: secondaryColorArr[2])
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "color")
        changeSideColors(2)
    }
    
    @IBAction func b4(sender: AnyObject) {
        let calcVC = self.parentViewController?.childViewControllers[0] as! ViewController
        calcVC.colorChanged(colorArr[3], secondaryColor: secondaryColorArr[3])
        NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "color")
        changeSideColors(3)

    }
    
    @IBAction func b6(sender: AnyObject) {
        let calcVC = self.parentViewController?.childViewControllers[0] as! ViewController
        calcVC.colorChanged(colorArr[4], secondaryColor: secondaryColorArr[4])
        NSUserDefaults.standardUserDefaults().setInteger(4, forKey: "color")
        changeSideColors(4)

    }
    
    let colorArr: [UIColor] = [MaterialColor.cyan.base, MaterialColor.red.base, MaterialColor.green.base, MaterialColor.deepPurple.base, MaterialColor.indigo.base, MaterialColor.orange.base]
    let secondaryColorArr: [UIColor] = [MaterialColor.red.lighten1, MaterialColor.indigo.base, MaterialColor.brown.base, MaterialColor.pink.base, MaterialColor.deepOrange.base]
    
    var expressionArr = [String]()
    var resultsArr = [String]()
    var mainColor = UIColor()
    var secondaryColor = UIColor()
    
    //grab the user's history and populate the table view. Cap at 15 results if necessary
    func loadHistory() {
        if NSUserDefaults.standardUserDefaults().objectForKey("expressionArr") != nil {
            expressionArr = NSUserDefaults.standardUserDefaults().objectForKey("expressionArr") as! [String]
            resultsArr = NSUserDefaults.standardUserDefaults().objectForKey("resultsArr") as! [String]
            if expressionArr.count > 15 {
                expressionArr = Array(expressionArr.suffix(15))
            }
            if resultsArr.count > 15 {
                resultsArr = Array(resultsArr.suffix(15))
            }
            resultsArr = resultsArr.reverse()
            expressionArr = expressionArr.reverse()
            self.historyTableView.reloadData()
        }
    }
    
    //Change the colors of the side navigation view
    func changeSideColors(clrIndex: Int) {
        self.view.backgroundColor = colorArr[clrIndex]
        mainColor = colorArr[clrIndex]
        secondaryColor = secondaryColorArr[clrIndex]
        historyTableView.reloadData()
    }
    
    //configure the view
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let colorArrInt = NSUserDefaults.standardUserDefaults().integerForKey("color")
        mainColor = self.colorArr[colorArrInt]
        secondaryColor = self.secondaryColorArr[colorArrInt]
        
        self.view.backgroundColor = mainColor
        var colorIndex = 0
        for button in colorButtons {
            button.backgroundColor = colorArr[colorIndex]
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.borderWidth = 2.0
            button.clipsToBounds = true
            colorIndex += 1
        }
        loadHistory()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expressionArr.count
    }
    
    //Configure the custom history cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as! HistoryTableViewCell
        cell.resultLabel.text = self.resultsArr[indexPath.row]
        cell.resultLabel.textColor = mainColor
        cell.expressionLabel.textColor = mainColor
        cell.expressionLabel.text = self.expressionArr[indexPath.row]
        cell.numberBtn.layer.cornerRadius = 0.5 * cell.numberBtn.bounds.size.width
        cell.numberBtn.setTitle(String(indexPath.row + 1), forState: .Normal)
        cell.numberBtn.backgroundColor = mainColor
        cell.selectionStyle = .None
        return cell
    }


}
