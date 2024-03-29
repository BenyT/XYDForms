//
//  XYDTextFieldDelegate.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var formController: XYDFormController!
    
    init(formController: XYDFormController) {
        super.init() 
        self.formController = formController
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let textField = textField as? YTextField {
            let field = formController.sections[textField.indexPath.section].fields[textField.indexPath.row]
            if let dateField = field as? XYDDateField {
                let datePickerViewController = XYDDatePickerViewController()
                datePickerViewController.field = dateField
                datePickerViewController.delegate = formController
                dateField.viewController.presentViewController(datePickerViewController, animated: true, completion: nil)
                return false
            } else if field.shouldShowSelector {
                field.showSelector!()
                return false
            } else {
                // Tell KeyboardHandler about the new active text field by sending a notification
                NSNotificationCenter.defaultCenter().postNotificationName(XYDKeyboardHandler.ActiveTextFieldUpdateNotification, object: textField)
            }
        }
        return true
    }
    
    // Apply text from textField in the correct Form Field. Show error message if needed. Call form's delegate if no error.
    func textFieldDidEndEditing(textField: UITextField) {
        if let textField = textField as? YTextField {
            let field = fieldForIndexPath(textField.indexPath)
            field.value = textField.text
            field.errorMessage = XYDValidator.errorMessageForText(textField.text!, withValidation: field.validation)
            (textField as! FloatLabelTextField).errorMessage = field.errorMessage
            if field.errorMessage == nil {
               formController.delegate?.formController(formController, updatedField: field, inSection: textField.indexPath.section)
            }
        } else {
            assertionFailure("textField should always be YTextField")
        }
    }
    
    // Handle maximum number of characters validation
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? YTextField {
            let field = fieldForIndexPath(textField.indexPath)
            if let validation = field.validation {
                if validation.maxCharacters > 0 && (textField.text!.characters.count + string.characters.count - range.length) > validation.maxCharacters {
                    return false
                }
            }
        }
        return true
    }
    
    // Hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
   
   func fieldForIndexPath(indexPath: NSIndexPath) -> XYDTextField {
      return formController.sections[indexPath.section].fields[indexPath.row] as! XYDTextField
   }
   
//   func fieldForTexField(textField: UITextField) -> XYDTextField {
//      return textField.superview?.superview as! XYDTextField
//   }
   
}
