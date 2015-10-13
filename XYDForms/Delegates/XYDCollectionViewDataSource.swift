//
//  XYDCollectionViewDataSource.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

extension XYDFormController: UICollectionViewDataSource {
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let field = sections[indexPath.section].fields[indexPath.row]
        switch field.type {
        case .Photo:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.PhotoField, forIndexPath: indexPath) as? XYDPhotoFieldCell
            cell?.viewController = self
            cell?.delegate = self
            return cell!
//        case .Tags:
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.TagField, forIndexPath: indexPath) as? XYDTagFieldCell
//            cell?.tagWriteView.delegate = self
//            return cell!
        case .Multiline:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.MultilineField, forIndexPath: indexPath) as? XYDMultilineFieldCell
            return cell!
        case .Switch:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.SwitchField, forIndexPath: indexPath) as? XYDSwitchFieldCell
            cell?.delegate = self
            cell?.indexPath = indexPath
            return cell!
        case .Date:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.DateField, forIndexPath: indexPath) as? XYDDateFieldCell
            cell?.textField.delegate = textFieldDelegate
            cell?.textField.indexPath = indexPath
            return cell!
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.TextField, forIndexPath: indexPath) as? XYDFieldCell
            // todo: RENAME TEXTFIELD
            if let textField = field as? XYDTextField {
                if let text = textField.value as? String {
//                    println(text)
                    cell?.textField.text = text
                } else {
                    cell?.textField.text = ""
                }
                cell?.textField.placeholder = textField.placeHolder
                cell?.textField.delegate = textFieldDelegate
                cell?.textField.errorMessage = textField.errorMessage
                cell?.textField.indexPath = indexPath
               
               if field.identifier == "email" {
                  cell?.backgroundColor = UIColor.greenColor()
                  cell?.contentView.backgroundColor = UIColor.blueColor()
               } else {
                  cell?.backgroundColor = UIColor.clearColor()
               }
                
            }
            
            return cell!
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].fields.count
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: XYZCells.Header, forIndexPath: indexPath) as! XYDFieldHeader
        headerView.titleLabel.text = sectionTitles![indexPath.section]
        return headerView
    }
    
}