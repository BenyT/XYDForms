//
//  YFormUtilities.swift
//  YForms
//
//  Created by Mateus, Diogo on 12/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class YFValidationUtilities: NSObject {
    
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
                if let errorMessage = YFValidationUtilities.errorMessageForText(field.text, withValidation: field.validation) {
                    field.errorMessage = errorMessage
                    field.textField?.errorMessage = errorMessage
                    passedValidation = false
                }
            }
        }
        return passedValidation
    }
    
}
