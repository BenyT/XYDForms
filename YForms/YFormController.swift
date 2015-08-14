//
//  YFormController.swift
//  YForms
//
//  Created by Mateus, Diogo on 05/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class YFormController: UIViewController {
    
    static let ActiveTextFieldUpdateNotification = "YActiveTextFieldUpdateNotification"
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: YFCollectionViewDataSource?
    var collectionViewDelegate: YFCollectionViewDelegate?
    var delegate: YFormDelegate?
    var keyboardHandler: YKeyboardHandler?

    init(cellViewName: String = "YFFieldCell") {
        super.init(nibName: nil, bundle: nil)
        // CollectionView Setup
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        // You can set a custom cell view
        collectionView.registerNib(UINib(nibName: cellViewName, bundle: nil), forCellWithReuseIdentifier: YFCollectionViewDataSource.cellIdentifier)
        collectionView.registerNib(UINib(nibName: "YFFieldHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: YFCollectionViewDataSource.headerIdentifier)
        
        // Delegates Setup
        collectionViewDataSource = YFCollectionViewDataSource()
        collectionViewDelegate = YFCollectionViewDelegate(dataSource: collectionViewDataSource!)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        keyboardHandler = YKeyboardHandler(formController: self)
        let textFieldDelegate = YTextFieldDelegate(formController: self)
        collectionViewDataSource?.textFieldDelegate = textFieldDelegate
        
        self.view.addSubview(collectionView)
        // Constraints Setup
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view":collectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view":collectionView]))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public Methods
    
    func addField(field: YFField, inSection section: Int = 0, withPercentageWidth percentageWidth: Double = 1, withValidation validation: YFValidation? = nil) {
        field.percentageWidth = percentageWidth
        field.validation = validation
        collectionViewDataSource?.addField(field, inSection: section)
    }
    
    // Section headers will only be displayed if you call this method
    // You can either send an array of strings with the same amount as the sections or you can the a string to apply the pattern: Person 1, Person 2, etc
    func setSectionTitles(sectionTitles: String...) {
        if sectionTitles.count == 1 && collectionViewDataSource?.sections.count > 1 {
            collectionViewDataSource?.sectionTitles = []
            for i in 0..<collectionViewDataSource!.sections.count {
                collectionViewDataSource?.sectionTitles?.append("\(sectionTitles.first!) \(i + 1)")
            }
        } else if sectionTitles.count == collectionViewDataSource?.sections.count {
            collectionViewDataSource?.sectionTitles = sectionTitles
        } else {
            assertionFailure("Number of section titles should be the same as the number of sections")
        }
        // Show headers
        let layout = collectionView.collectionViewLayout
        (layout as? UICollectionViewFlowLayout)!.headerReferenceSize = CGSizeMake(collectionView.frame.width, 30) // TODO: get height of xib or constant
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func validateFields() -> Bool {
        return YFValidationUtilities.validateFields(collectionViewDataSource!.sections)
    }
    
}

protocol YFormDelegate {
    func formController(formController: YFormController, updatedField field: YFBasicField, atIndexPath indexPath: NSIndexPath)
}

// TODO: Move to another File
class YTextField: UITextField {
    var indexPath: NSIndexPath!
}


