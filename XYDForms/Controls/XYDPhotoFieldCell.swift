//
//  XYDPhotoFieldCell.swift
//  MealsApp
//
//  Created by Meals App on 19/09/15.
//  Copyright (c) 2015 mateusd. All rights reserved.
//

import UIKit

class XYDPhotoFieldCell: XYDCollectionViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var delegate: XYDPhotoFieldCellDelegate?
    var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func actionPhoto(sender: AnyObject) {
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum;
        imagePicker.allowsEditing = true
        viewController.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        delegate?.photoFieldCellDelegate(self, didFinishPickingImage: image)
    }
    
}

protocol XYDPhotoFieldCellDelegate {
    func photoFieldCellDelegate(cell: XYDPhotoFieldCell, didFinishPickingImage image: UIImage!)
}