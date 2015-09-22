//
//  YFormModel.swift
//  YForms
//
//  Created by Mateus, Diogo on 10/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class XYFDateField: XYDTextField {
    
    var viewController: UIViewController!
    
    init(identifier: String, placeHolder: String, viewController: UIViewController) {
        super.init(identifier: identifier, placeHolder: placeHolder)
        self.type = .Date
        self.viewController = viewController
    }
    
}

struct YFSection {
    
    var fields: [XYDField] = []
    
}

// MARK: Validation

struct YFValidation {
    
    var maxCharacters: Int = 0
    var characterValidation: YFCharacterValidation = .None
    var isMandatory: Bool = false
    var mandatoryErrorMessage: String?
    var regexValidations: [YFRegexValidation]
    
    init(characterValidation: YFCharacterValidation = .None, isMandatoryWithErrorMessage mandatoryErrorMessage: String = "", maxCharacters: Int = 0, regexValidations: [YFRegexValidation] = []) {
        self.characterValidation = characterValidation
        self.maxCharacters = maxCharacters
        if mandatoryErrorMessage != "" {
            isMandatory = true
            self.mandatoryErrorMessage = mandatoryErrorMessage
        }
        self.regexValidations = regexValidations
    }
    
}

struct YFRegexValidation {
    
    var regex: String
    var errorMessage: String
    
    init(regex: String, errorMessage: String) {
        self.regex = regex
        self.errorMessage = errorMessage
    }
    
}

enum YFCharacterValidation {
    case None, OnlyLetters, OnlyLettersAndDigits
}

enum YFFieldType {
    case Text, Numbers, Email, Date, Tags, Photo, Multiline, Switch/*, Stepper*/
}


