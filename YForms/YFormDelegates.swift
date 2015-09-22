//
//  YFormDelegates.swift
//  YForms
//
//  Created by Mateus, Diogo on 12/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class XYFCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
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

// This CollectionView delegate's purpose is to calculate the size of each cell, taking into account the percentage width of each field.
class YFCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var formController: YFormController!
    
    init(formController: YFormController) {
        self.formController = formController
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let field = formController.collectionViewDataSource!.sections[indexPath.section].fields[indexPath.row]
        return CGSizeMake(collectionView.frame.width * CGFloat(field.percentageWidth), formController.fieldHeight * field.heightMultiplier)
    }
    
}

class YFCollectionViewDataSource: NSObject, UICollectionViewDataSource, TagWriteViewDelegate, YFPhotoFieldCellDelegate, XYZSwitchFieldCellDelegate, XYFDatePickerViewControllerDelegate {
    
    var sections: [YFSection] = []
    var textFieldDelegate: YFTextFieldDelegate!
    var sectionTitles: [String]?
    
    var formController: YFormController!
    
    init(formController: YFormController) {
        self.formController = formController
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let field = sections[indexPath.section].fields[indexPath.row]
        
        switch field.type {
        case .Photo:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.PhotoField, forIndexPath: indexPath) as? YFPhotoFieldCell
            cell?.viewController = formController
            cell?.delegate = self
            return cell!
        case .Tags:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.TagField, forIndexPath: indexPath) as? YFTagFieldCell
            cell?.tagWriteView.delegate = self
            return cell!
        case .Multiline:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.MultilineField, forIndexPath: indexPath) as? XYZMultilineFieldCell
            return cell!
        case .Switch:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.SwitchField, forIndexPath: indexPath) as? XYZSwitchFieldCell
            cell?.delegate = self
            cell?.indexPath = indexPath
            return cell!
        case .Date:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.DateField, forIndexPath: indexPath) as? XYZDateFieldCell
            cell?.textField.delegate = textFieldDelegate
            cell?.textField.indexPath = indexPath
            return cell!
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XYZCells.TextField, forIndexPath: indexPath) as? YFFieldCell
            // todo: RENAME TEXTFIELD
            if let textField = field as? YFTextField {
                textField.textField = cell?.textField
                if let text = textField.value as? String {
                    cell?.textField.text = text
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
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: XYZCells.Header, forIndexPath: indexPath) as! YFFieldHeader
        headerView.titleLabel.text = sectionTitles![indexPath.section]
        return headerView
    }
    
    func addField(newField: YFField, inSection section: Int) {
        if sections.count <= section {
            // Create new section
            sections.insert(YFSection(), atIndex: section)
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
    
    func photoFieldCellDelegate(cell: YFPhotoFieldCell, didFinishPickingImage image: UIImage!) {
        cell.photoButton.setBackgroundImage(image, forState: UIControlState.Normal)
        //        formController.delegate?.formController(formController, updatedField: <#YFBasicField#>, atIndexPath: <#NSIndexPath#>)
    }
    
    func switchFieldCell(switchFieldCell: XYZSwitchFieldCell, newValue: Bool) {
        let field = sections[switchFieldCell.indexPath.section].fields[switchFieldCell.indexPath.row]
        field.value = newValue
        formController.delegate?.formController(formController, updatedField: field, atIndexPath: (field.identifier, switchFieldCell.indexPath.section))
    }
    
    func datePickerViewController(field: XYFDateField, date: NSDate) {
        field.value = date
        formController.delegate?.formController(formController, updatedField: field, atIndexPath: (field.identifier, 0))
        // todo: fill text field
    }
    
}

class YFTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var formController: YFormController!
    
    init(formController: YFormController) {
        super.init()
        self.formController = formController
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let textField = textField as? YTextField {
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row]
            if let dateField = field as? XYFDateField {
                let datePickerViewController = DatePickerViewController()
                datePickerViewController.field = dateField
                datePickerViewController.delegate = formController.collectionViewDataSource
                dateField.viewController.presentViewController(datePickerViewController, animated: true, completion: nil)
                return false
            } else if field.shouldShowSelector {
                field.showSelector!()
                return false
            } else {
                // Tell KeyboardHandler about the new active text field by sending a notification
                NSNotificationCenter.defaultCenter().postNotificationName(YFKeyboardHandler.ActiveTextFieldUpdateNotification, object: textField)
            }
        }
        return true
    }
    
    // Apply text from textField in the correct Form Field. Show error message if needed. Call form's delegate if no error.
    func textFieldDidEndEditing(textField: UITextField) {
        if let textField = textField as? YTextField {
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row] as! YFTextField
            field.value = textField.text
            field.errorMessage = YFValidationUtilities.errorMessageForText(textField.text, withValidation: field.validation)
            (textField as! FloatLabelTextField).errorMessage = field.errorMessage
            if field.errorMessage == nil {
                formController.delegate?.formController(formController, updatedField: field, atIndexPath: (field.identifier, textField.indexPath.section))
            }
        } else {
            assertionFailure("textField should always be YTextField")
        }
    }
    
    // Handle maximum number of characters validation
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? YTextField {
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row] // TODO: custom method to get this
            if let validation = field.validation {
                if validation.maxCharacters > 0 && (count(textField.text) + count(string) - range.length) > validation.maxCharacters {
                    return false
                }
            }
        }
        return true
    }
    
    // Hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

class YFKeyboardHandler: NSObject {
    
    /* When the keyboard appears, a part of the collection view might get hidden. This delegate will add a bottom padding to the collection view, so it is visible and will scroll it if needed */
    
    static let ActiveTextFieldUpdateNotification = "YActiveTextFieldUpdateNotification"
    
    private var formController: YFormController!
    private var keyboardFrame : CGRect?
    private var activeTextField: YTextField?
    
    init(formController: YFormController) {
        super.init()
        self.formController = formController
        // Subscribe to keyboard listeners
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardDidHideNotification, object: nil)
        // Subscribe to ActiveTextField listener from the YTextFieldDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeTextFieldUpdated:", name:YFKeyboardHandler.ActiveTextFieldUpdateNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Add bottom padding and scroll if needed
    func keyboardShown(notification: NSNotification) {
        if let textField = activeTextField {
            if keyboardFrame == nil {
                // Get the cell's frame
                let value: AnyObject = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!
                keyboardFrame = formController.view.convertRect(value.CGRectValue(), fromView: nil)
            }
            // Apply bottom padding
            let intersection = CGRectIntersection(formController.collectionView!.frame, keyboardFrame!)
            let collectionViewInsets = UIEdgeInsetsMake(0, 0, intersection.height, 0)
            formController.collectionView!.contentInset = collectionViewInsets
            formController.collectionView!.scrollIndicatorInsets = collectionViewInsets
            // Should scroll?
            let currentIndexPath = activeTextField!.indexPath
            var visibileItemsItemsPaths: [NSIndexPath] = formController.collectionView!.indexPathsForVisibleItems() as! [NSIndexPath]
            let activeCellIsHidden = visibileItemsItemsPaths.filter { (indexPath) -> Bool in
                return indexPath == currentIndexPath
                }.count == 0
            if activeCellIsHidden {
                formController.collectionView?.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    func keyboardHidden(notification: NSNotification) {
        formController.collectionView!.contentInset = UIEdgeInsetsZero
        formController.collectionView!.scrollIndicatorInsets = UIEdgeInsetsZero
        
    }
    
    // Called by YTextFieldDelegate. Update active text field
    func activeTextFieldUpdated(notification: NSNotification) {
        if let activeTextField = notification.object as? YTextField {
            self.activeTextField = activeTextField
        }
    }
    
}

struct XYZCells {
    static let TextField = "YFFieldCell"
    static let Header = "YFFieldHeader"
    static let TagField = "YFTagFieldCell"
    static let PhotoField = "YFPhotoFieldCell"
    static let MultilineField = "XYZMultilineFieldCell"
    static let SwitchField = "XYZSwitchFieldCell"
    static let DateField = "XYZDateFieldCell"
    
}

class XYZCollectionViewCell: UICollectionViewCell {
    
    var indexPath: NSIndexPath!
    
}

typealias XYZIndexPath = (String, Int)
