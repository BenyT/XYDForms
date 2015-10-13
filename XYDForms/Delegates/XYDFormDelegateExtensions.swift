//
//  XYDFormDelegateExtensions.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 13/10/2015.
//  Copyright © 2015 Diogo Mateus. All rights reserved.
//

import UIKit

extension XYDFormController: XYDPhotoFieldCellDelegate {

   func photoFieldCellDelegate(cell: XYDPhotoFieldCell, didFinishPickingImage image: UIImage!) {
      cell.photoButton.setBackgroundImage(image, forState: UIControlState.Normal)
//        formController.delegate?.formController(formController, updatedField: <#YFBasicField#>, atIndexPath: <#NSIndexPath#>)
   }
   
}

extension XYDFormController: XYDSwitchFieldCellDelegate {
   
   func switchFieldCell(switchFieldCell: XYDSwitchFieldCell, newValue: Bool) {
      let field = sections[switchFieldCell.indexPath.section].fields[switchFieldCell.indexPath.row]
      field.value = newValue
      delegate?.formController(self, updatedField: field, inSection: switchFieldCell.indexPath.section)
   }
   
}

extension XYDFormController: XYDDatePickerViewControllerDelegate {
   
   func datePickerViewController(field: XYDDateField, date: NSDate) {
      field.value = date
      delegate?.formController(self, updatedField: field, inSection: 0)
      // todo: fill text field
   }
   
}
