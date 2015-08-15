//
//  YFormDelegates.swift
//  YForms
//
//  Created by Mateus, Diogo on 12/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

// This CollectionView delegate's purpose is to calculate the size of each cell, taking into account the percentage width of each field.
class YFCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var formController: YFormController!
    
    init(formController: YFormController) {
        self.formController = formController
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let field = formController.collectionViewDataSource!.sections[indexPath.section].fields[indexPath.row]
        return CGSizeMake(collectionView.frame.width * CGFloat(field.percentageWidth), formController.fieldHeight)
    }
    
}

class YFCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    static let cellIdentifier: String = "YFFieldCellIdentifier"
    static let headerIdentifier: String = "YFFieldHeaderIdentifier"
    
    var sections: [YFSection] = []
    var textFieldDelegate: YFTextFieldDelegate!
    var sectionTitles: [String]?
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(YFCollectionViewDataSource.cellIdentifier, forIndexPath: indexPath) as? YFFieldCell
        let field = sections[indexPath.section].fields[indexPath.row]
        field.textField = cell?.textField
        cell?.textField.text = field.text
        cell?.textField.placeholder = field.placeHolder
        cell?.textField.delegate = textFieldDelegate
        cell?.textField.errorMessage = field.errorMessage
        cell?.textField.indexPath = indexPath
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].fields.count
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: YFCollectionViewDataSource.headerIdentifier, forIndexPath: indexPath) as! YFFieldHeader
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
            // Should show selector?
            if field.shouldShowSelector {
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
            let field = formController.collectionViewDataSource!.sections[textField.indexPath.section].fields[textField.indexPath.row]
            field.text = textField.text
            field.errorMessage = YFValidationUtilities.errorMessageForText(textField.text, withValidation: field.validation)
            (textField as! FloatLabelTextField).errorMessage = field.errorMessage
            if field.errorMessage == nil {
                formController.delegate?.formController(formController, updatedField: field as YFBasicField, atIndexPath: textField.indexPath)
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
