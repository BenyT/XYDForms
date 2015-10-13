//
//  XYDCollectionViewDelegate.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

extension XYDFormController: UICollectionViewDelegate  {
   
   // todo: indent
   
   func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      let field = sections[indexPath.section].fields[indexPath.row]
      print("width: \(collectionView.frame.width)")
      if field.identifier == "email" {
         print(field.percentageWidth)
      }
      return CGSizeMake(collectionView.frame.width * CGFloat(field.percentageWidth), fieldHeight * field.heightMultiplier)
   }
   
}
