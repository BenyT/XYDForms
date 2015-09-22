//
//  XYDValidation.swift
//  YFormsDemo
//
//  Created by Meals App on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

struct XYDValidation {
    
    var maxCharacters: Int = 0
    var characterValidation: XYDCharacterValidation = .None
    var isMandatory: Bool = false
    var mandatoryErrorMessage: String?
    var regexValidations: [XYDRegexValidation]
    
    init(characterValidation: XYDCharacterValidation = .None, isMandatoryWithErrorMessage mandatoryErrorMessage: String = "", maxCharacters: Int = 0, regexValidations: [XYDRegexValidation] = []) {
        self.characterValidation = characterValidation
        self.maxCharacters = maxCharacters
        if mandatoryErrorMessage != "" {
            isMandatory = true
            self.mandatoryErrorMessage = mandatoryErrorMessage
        }
        self.regexValidations = regexValidations
    }
    
}
