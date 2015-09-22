//
//  XYZSwitchFieldCell.swift
//  MealsApp
//
//  Created by Meals App on 20/09/15.
//  Copyright (c) 2015 mateusd. All rights reserved.
//

import UIKit

class XYZSwitchFieldCell: XYZCollectionViewCell {

    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: XYZSwitchFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.switchFieldCell(self, newValue: switchControl.on)
    }
}

protocol XYZSwitchFieldCellDelegate {
    func switchFieldCell(switchFieldCell: XYZSwitchFieldCell, newValue: Bool)
}
