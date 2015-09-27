//
//  XYDFormController.swift
//  YForms
//
//  Created by Mateus, Diogo on 05/08/15.
//  Copyright (c) 2015 Mateus, Diogo. All rights reserved.
//

import UIKit

class XYDFormController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: XYDCollectionViewDataSource?
    var collectionViewDelegate: XYDCollectionViewDelegate?
    var delegate: XYDFormDelegate?
    var keyboardHandler: XYDKeyboardHandler?
    
    var fieldHeight: CGFloat = 50
    var cornerRadius: CGFloat = 0 {
        didSet {
            collectionView.layer.cornerRadius = cornerRadius
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        // CollectionView Setup
        let layout = UICollectionViewFlowLayout()
//        let layout = XYDCollectionViewFlowLayout()
//        layout.formController = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        // You can set a custom cell view
        collectionView.registerNib(UINib(nibName: XYZCells.TextField, bundle: nil), forCellWithReuseIdentifier: XYZCells.TextField)
        collectionView.registerNib(UINib(nibName: XYZCells.Header, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: XYZCells.Header)
        collectionView.registerNib(UINib(nibName: XYZCells.TagField, bundle: nil), forCellWithReuseIdentifier: XYZCells.TagField)
        collectionView.registerNib(UINib(nibName: XYZCells.PhotoField, bundle: nil), forCellWithReuseIdentifier: XYZCells.PhotoField)
        collectionView.registerNib(UINib(nibName: XYZCells.MultilineField, bundle: nil), forCellWithReuseIdentifier: XYZCells.MultilineField)
        collectionView.registerNib(UINib(nibName: XYZCells.MultilineField, bundle: nil), forCellWithReuseIdentifier: XYZCells.MultilineField)
        collectionView.registerNib(UINib(nibName: XYZCells.SwitchField, bundle: nil), forCellWithReuseIdentifier: XYZCells.SwitchField)
        collectionView.registerNib(UINib(nibName: XYZCells.DateField, bundle: nil), forCellWithReuseIdentifier: XYZCells.DateField)
        
        // Delegates Setup
        collectionViewDataSource = XYDCollectionViewDataSource(formController: self)
        collectionViewDelegate = XYDCollectionViewDelegate(formController: self)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        keyboardHandler = XYDKeyboardHandler(formController: self)
        let textFieldDelegate = XYDTextFieldDelegate(formController: self)
        collectionViewDataSource?.textFieldDelegate = textFieldDelegate
        
        self.view.addSubview(collectionView)
        // Constraints Setup
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": collectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": collectionView]))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public Methods
    
    func addField(field: XYDField, inSection section: Int = 0) {
        collectionViewDataSource?.addField(field, inSection: section)
    }
    
    // Add a field with a selector
    func addField(field: XYDField, inSection section: Int = 0, showSelector: () -> ()) {
        field.showSelector = showSelector
        collectionViewDataSource?.addField(field, inSection: section)
    }
    
    /* Updates the field with 'fieldIdentifier' with 'text'
     * Added to allow 
        - Selectors
        - Fields pre-populating other fields
    */
    func setText(text: String, inFieldWithIdentifier fieldIdentifier: String, inSection section: Int = 0) {
        if let fields = collectionViewDataSource?.sections[section].fields {
            for (index, field) in enumerate(fields) {
                if field.identifier == fieldIdentifier {
                    // Update field with text
                    field.value = text
                    let indexPath = NSIndexPath(forRow: index, inSection: section)
                    delegate?.formController(self, updatedField: field, inSection: indexPath.section)
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                    break
                }
            }
        }
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
      let formIsValid = XYDValidator.validateFields(collectionViewDataSource!.sections)
      if !formIsValid {
         collectionView.reloadData()
      }
        return formIsValid
    }
    
}

// TODO: Move to another File
class YTextField: UITextField {
    var indexPath: NSIndexPath!
}


