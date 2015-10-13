//
//  XYDKeyboardHandler.swift
//  XYDForms
//
//  Created by Mateus, Diogo on 23/09/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//
import UIKit

class XYDKeyboardHandler: NSObject {
    
    /* When the keyboard appears, a part of the collection view might get hidden. This delegate will add a bottom padding to the collection view, so it is visible and will scroll it if needed */
    
    static let ActiveTextFieldUpdateNotification = "YActiveTextFieldUpdateNotification"
    
    private var formController: XYDFormController!
    private var keyboardFrame : CGRect?
    private var activeTextField: YTextField?
    
    init(formController: XYDFormController) {
        super.init()
        self.formController = formController
        // Subscribe to keyboard listeners
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardDidHideNotification, object: nil)
        // Subscribe to ActiveTextField listener from the YTextFieldDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeTextFieldUpdated:", name:XYDKeyboardHandler.ActiveTextFieldUpdateNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Add bottom padding and scroll if needed
    func keyboardShown(notification: NSNotification) {
        if let _ = activeTextField {
            if keyboardFrame == nil {
                // Get the cell's frame
                let value: AnyObject = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!
                keyboardFrame = formController.view.convertRect(value.CGRectValue, fromView: nil)
            }
            // Apply bottom padding
            let intersection = CGRectIntersection(formController.collectionView!.frame, keyboardFrame!)
            let collectionViewInsets = UIEdgeInsetsMake(0, 0, intersection.height, 0)
            formController.collectionView!.contentInset = collectionViewInsets
            formController.collectionView!.scrollIndicatorInsets = collectionViewInsets
            // Should scroll?
            let currentIndexPath = activeTextField!.indexPath
            let visibileItemsItemsPaths: [NSIndexPath] = formController.collectionView!.indexPathsForVisibleItems()
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
