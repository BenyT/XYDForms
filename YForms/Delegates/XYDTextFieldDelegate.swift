//
//  XYDTextFieldDelegate.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var formController: YFormController!
    
    init(formController: YFormController) {
        super.init()
        self.formController = formController
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let textField = textField as? YTextField {
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row]
            if let dateField = field as? XYDDateField {
                let datePickerViewController = DatePickerViewController()
                datePickerViewController.field = dateField
                datePickerViewController.delegate = formController.collectionViewDataSource
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
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row] as! XYDTextField
            field.value = textField.text
            field.errorMessage = XYDValidator.errorMessageForText(textField.text, withValidation: field.validation)
            (textField as! FloatLabelTextField).errorMessage = field.errorMessage
            if field.errorMessage == nil {
                formController.delegate?.formController(formController, updatedField: field, atIndexPath: (field.identifier, textField.indexPath.section))
            }
        } else {
            assertionFailure("textField should always be YTextField")
        }
    }
    
    // Handle maximum number of characters validation
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? YTextField {
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row] // TODO: custom method to get this
            if let validation = field.validation {
                if validation.maxCharacters > 0 && (count(textField.text) + count(string) - range.length) > validation.maxCharacters {
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
    
}
