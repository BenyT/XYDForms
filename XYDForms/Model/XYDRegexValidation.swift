//
//  XYDRegexValidation.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

struct XYDRegexValidation {
    
    var regex: String
    var errorMessage: String
    
    init(regex: String, errorMessage: String) {
        self.regex = regex
        self.errorMessage = errorMessage
    }
    
}
