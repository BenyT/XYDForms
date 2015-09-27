//
//  XYDCollectionViewDataSource.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit

class XYDCollectionViewDataSource: NSObject, UICollectionViewDataSource, TagWriteViewDelegate, XYDPhotoFieldCellDelegate, XYDSwitchFieldCellDelegate, XYDDatePickerViewControllerDelegate {
    
    var sections: [XYDSection] = []
    var textFieldDelegate: XYDTextFieldDelegate!
    var sectionTitles: [String]?
    
    var formController: XYDFormController!
    
    init(formController: XYDFormController) {
        self.formController = formController
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let field = sections[indexPath.section].fields[indexPath.row]
        
        switch field.type {
        case .Photo:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.PhotoField, forIndexPath: indexPath) as? XYDPhotoFieldCell
            cell?.viewController = formController
            cell?.delegate = self
            return cell!
        case .Tags:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.TagField, forIndexPath: indexPath) as? XYDTagFieldCell
            cell?.tagWriteView.delegate = self
            return cell!
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
                textField.textField = cell?.textField
                if let text = textField.value as? String {
                    println(text)
                    cell?.textField.text = text
                } else {
                    cell?.textField.text = ""
                }
                cell?.textField.placeholder = textField.placeHolder
                cell?.textField.delegate = textFieldDelegate
                cell?.textField.errorMessage = textField.errorMessage
                cell?.textField.indexPath = indexPath
                
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
    
    func addField(newField: XYDField, inSection section: Int) {
        if sections.count <= section {
            // Create new section
            sections.insert(XYDSection(), atIndex: section)
        }
        sections[section].fields.append(newField)
    }
    
    // MARK: TagWriteViewDelegate
    
    func tagWriteViewDidEndEditing(view: TagWriteView!) {
        println(view.tags)
        //        formController.delegate?.formController(formController, updatedField: view.superview, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }
    
    func tagWriteView(view: TagWriteView!, didRemoveTag tag: String!) {
        println(view.tags)
    }
    
    
    // MARK: ImagePickerManagerDelegate
    
    func photoFieldCellDelegate(cell: XYDPhotoFieldCell, didFinishPickingImage image: UIImage!) {
        cell.photoButton.setBackgroundImage(image, forState: UIControlState.Normal)
        //        formController.delegate?.formController(formController, updatedField: <#YFBasicField#>, atIndexPath: <#NSIndexPath#>)
    }
    
    func switchFieldCell(switchFieldCell: XYDSwitchFieldCell, newValue: Bool) {
        let field = sections[switchFieldCell.indexPath.section].fields[switchFieldCell.indexPath.row]
        field.value = newValue
        formController.delegate?.formController(formController, updatedField: field, inSection: switchFieldCell.indexPath.section)
    }
    
    func datePickerViewController(field: XYDDateField, date: NSDate) {
        field.value = date
        formController.delegate?.formController(formController, updatedField: field, inSection: 0)
        // todo: fill text field
    }
    
}