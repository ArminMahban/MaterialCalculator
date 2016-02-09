//
//  HistoryTableViewCell.swift
//  Calculator
//
//  Created by ArminM on 2/7/16.
//  Copyright © 2016 ArminM. All rights reserved.
//

import UIKit

/**

 Class to hold the custom TableViewCell
 
*/
class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var numberBtn: UIButton!
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
