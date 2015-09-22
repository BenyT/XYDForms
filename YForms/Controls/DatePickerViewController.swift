//
//  DatePickerViewController.swift
//  MealsApp
//
//  Created by Meals App on 20/09/15.
//  Copyright (c) 2015 mateusd. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var field: XYFDateField!
    var delegate: XYFDatePickerViewControllerDelegate?
    
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

protocol XYFDatePickerViewControllerDelegate {
    func datePickerViewController(field: XYFDateField, date: NSDate)
}
