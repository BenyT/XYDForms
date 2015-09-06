//
//  YFormModel.swift
//  YForms
//
//  Created by Mateus, Diogo on 10/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

/* This file contains the following Structs:
    - Basic Field
    - Field
    - Validation
    - RegexValidation
*/

// MARK: Field

class YFBasicField: NSObject {
    
    private (set) var identifier: String = ""
    var text: String = ""
    var type: YFFieldType = .Text
    
    init(identifier: String, text: String, type: YFFieldType) {
        super.init()
        self.identifier = identifier
        self.text = text
        self.type = type
    }
    
}

class YFField: YFBasicField {
    
    private (set) var placeHolder: String = ""
    var validation: YFValidation?
    var textField: FloatLabelTextField?
    var errorMessage: String?
    var percentageWidth: Double = 1
    
    // Handle selectors
    private (set) var shouldShowSelector: Bool = false
    var showSelector: (() -> ())? {
        didSet {
            shouldShowSelector = true
        }
    }
    
    init(identifier: String, placeHolder: String, type: YFFieldType = .Text) {
        super.init(identifier: identifier, text: "", type: type)
        self.placeHolder = placeHolder
    }
    
}

struct YFSection {
    
    var fields: [YFField] = []
    
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
    case Text, Numbers, Email, Date/*, Switch, Stepper*/
}


