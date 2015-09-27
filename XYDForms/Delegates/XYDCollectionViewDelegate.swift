//
//  XYDCollectionViewDelegate.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDCollectionViewDelegate: NSObject, UICollectionViewDelegate  {
    
    var formController: XYDFormController!
    
    init(formController: XYDFormController) {
        self.formController = formController
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let field = formController.collectionViewDataSource!.sections[indexPath.section].fields[indexPath.row]
        return CGSizeMake(collectionView.frame.width * CGFloat(field.percentageWidth), formController.fieldHeight * field.heightMultiplier)
    }
    
}
