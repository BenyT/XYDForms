//
//  XYDCollectionViewFlowLayout.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDCollectionViewFlowLayout: UICollectionViewFlowLayout {
   
    var formController: YFormController!
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        
        // TODO: SUPPORT MORE SECTIONS
        
        var yOffset: CGFloat = 0
        var xOffset: CGFloat = 0
        var currentWidthPercentage: CGFloat = 0
        
        
        var numberOfInnerRows: CGFloat = 0
        var currentInnerRow: CGFloat = 0
        
        
        for section in 0..<collectionView!.numberOfSections() {
            for item in 0..<collectionView!.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                
                let field = formController.collectionViewDataSource!.sections[section].fields[item]
                
                let width = collectionView!.frame.width * field.percentageWidth
                let height = formController.fieldHeight * field.heightMultiplier
                
                let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
                
                
                // 3rd onwards - 8-9-10
                if currentInnerRow > 0 {
                    currentInnerRow++
                    yOffset += height
                    
                }
                
                // 7
                if field.heightMultiplier > 1 && numberOfInnerRows == 0 {
                    numberOfInnerRows = field.heightMultiplier
                    currentInnerRow = 1
                    yOffset += height / field.heightMultiplier
                }
                
                xOffset += width
                
                if xOffset == collectionView!.frame.width || currentInnerRow > 0 {
                    xOffset = 0
                    if numberOfInnerRows == currentInnerRow {
                        yOffset += height
                        currentInnerRow = 0
                        numberOfInnerRows = 0
                    }
                } else if currentWidthPercentage > 1 {
                    assertionFailure("A row can't have a width percentage superior to 1")
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = CGRectInset(frame, 0, 0)
                cache.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}