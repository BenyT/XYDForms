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

class YFField: NSObject {
    
    private (set) var identifier: String = ""
    var value: AnyObject?
    var type: YFFieldType = .Text
    
    var validation: YFValidation?

    var percentageWidth: CGFloat = 1
    var heightMultiplier: CGFloat = 1
    
    // Handle selectors
    private (set) var shouldShowSelector: Bool = false
    var showSelector: (() -> ())? {
        didSet {
            shouldShowSelector = true
        }
    }
    
    init(identifier: String, type: YFFieldType = .Text) {
        self.identifier = identifier
        self.type = type
    }
    
}

class YFTextField: YFField {
    
    var textField: FloatLabelTextField?
    var errorMessage: String?

    private (set) var placeHolder: String = ""

    init(identifier: String, placeHolder: String) {
        super.init(identifier: identifier, type: .Text)
        self.placeHolder = placeHolder
    }
    
}

class XYFDateField: YFTextField {
    
    var viewController: UIViewController!
    
    init(identifier: String, placeHolder: String, viewController: UIViewController) {
        super.init(identifier: identifier, placeHolder: placeHolder)
        self.type = .Date
        self.viewController = viewController
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
    case Text, Numbers, Email, Date, Tags, Photo, Multiline, Switch/*, Stepper*/
}


