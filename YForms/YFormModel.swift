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
    
    private (set) var name: String = ""
    var text: String = ""
    
    init(name: String, text: String) {
        super.init()
        self.name = name
        self.text = text
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
    
    init(name: String, placeHolder : String) {
        super.init(name: name, text: "")
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
    case None, OnlyLetters, OnlyDigits, OnlyLettersAndDigits
}


