//
//  XYDDateField.swift
//  YFormsDemo
//
//  Created by Meals App on 22/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDDateField: XYDTextField {
    
    var viewController: UIViewController!
    
    init(identifier: String, placeHolder: String, viewController: UIViewController) {
        super.init(identifier: identifier, placeHolder: placeHolder)
        self.type = .Date
        self.viewController = viewController
    }
    
}
