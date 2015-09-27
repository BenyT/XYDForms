//
//  XYDFormDelegate.swift
//  YForms
//
//  Created by Mateus, Diogo on 27/09/2015.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

protocol XYDFormDelegate {
   func formController(formController: XYDFormController, updatedField field: XYDField, inSection section: Int)
}