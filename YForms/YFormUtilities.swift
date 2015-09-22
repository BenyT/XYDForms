//
//  YFormUtilities.swift
//  YForms
//
//  Created by Mateus, Diogo on 12/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class YFValidationUtilities: NSObject {
    
    
    // todo: validation is done only for text
    // to check: faz sentido os fields terem o textField?
    
    class func errorMessageForText(text: String, withValidation validation: YFValidation?) -> String? {
        if let validation = validation {
            if validation.isMandatory && text == "" {
                return validation.mandatoryErrorMessage
            }
            for regexValidation in validation.regexValidations {
                if !text.matchRegex(Regex(pattern: regexValidation.regex)) {
                    return regexValidation.errorMessage
                }
            }
        }
        return nil
    }
    
    class func validateFields(sections: [YFSection]) -> Bool {
        var passedValidation = true
        for section in sections {
            for field in section.fields {
                if let textField = field as? XYDTextField, text = textField.value as? String, errorMessage = YFValidationUtilities.errorMessageForText(text, withValidation: textField.validation) {
                    textField.errorMessage = errorMessage
                    textField.textField?.errorMessage = errorMessage
                    passedValidation = false
                }
            }
        }
        return passedValidation
    }
    
}
