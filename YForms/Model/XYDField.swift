//
//  XYDField.swift
//  YFormsDemo
//
//  Created by Meals App on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDField: NSObject {
   
    private (set) var identifier: String = ""
    var value: AnyObject?
    var type: XYDFieldType = .Text
    
    var validation: XYDValidation?
    
    var percentageWidth: CGFloat = 1
    var heightMultiplier: CGFloat = 1
    
    // Handle selectors
    private (set) var shouldShowSelector: Bool = false
    var showSelector: (() -> ())? {
        didSet {
            shouldShowSelector = true
        }
    }
    
    init(identifier: String, type: XYDFieldType = .Text) {
        self.identifier = identifier
        self.type = type
    }
    
}
