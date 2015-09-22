//
//  YFormModel.swift
//  YForms
//
//  Created by Mateus, Diogo on 10/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

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


