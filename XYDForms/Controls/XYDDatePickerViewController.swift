//
//  XYDDatePickerViewController.swift
//  MealsApp
//
//  Created by Meals App on 20/09/15.
//  Copyright (c) 2015 mateusd. All rights reserved.
//

import UIKit

class XYDDatePickerViewController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var field: XYDDateField!
    var delegate: XYDDatePickerViewControllerDelegate?
    
    override var nibName: String {
        return "DatePickerViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionDone(sender: AnyObject) {
        delegate?.datePickerViewController(field, date: datePicker.date)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

protocol XYDDatePickerViewControllerDelegate {
    func datePickerViewController(field: XYDDateField, date: NSDate)
}
