//
//  XYDTextField.swift
//  YFormsDemo
//
//  Created by Meals App on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDTextField: XYDField {
    
    var textField: FloatLabelTextField?
    var errorMessage: String?
    
    private (set) var placeHolder: String = ""
    
    init(identifier: String, placeHolder: String) {
        super.init(identifier: identifier, type: .Text)
        self.placeHolder = placeHolder
    }
    
}
