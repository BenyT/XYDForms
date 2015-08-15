//
//  MainViewController.swift
//  YFormsDemo
//
//  Created by Mateus, Diogo on 13/08/15.
//  Copyright (c) 2015 DiogoMateus. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, YFormDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    
    private var formController: YFormController!
    private var persons: [Person] = []
    
    private static let seguePushEnd = "seguePushEnd"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Validations Setup
        let emailRegex = "^([\\w-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([\\w-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        let emailErrorMessage = "Email is not valid"
        let emailValidation = YFRegexValidation(regex: emailRegex, errorMessage: emailErrorMessage)
        let validation = YFValidation(isMandatoryWithErrorMessage: "Email is mandatory", regexValidations: [emailValidation])
        let nameValidation = YFValidation(isMandatoryWithErrorMessage: "First name is mandatory", maxCharacters: 10)
        let lastNameValidation = YFValidation(isMandatoryWithErrorMessage: "Last name is mandatory", maxCharacters: 10)
                
        // Fields setup
        persons = [Person(), Person()]
        formController = YFormController()
        formController.delegate = self
        for i in 0..<persons.count {
            formController.addField(YFField(name: "firstName", placeHolder: "First Name"), inSection: i, withPercentageWidth: 0.5, withValidation: nameValidation)
            formController.addField(YFField(name: "lastName", placeHolder: "Last Name"), inSection: i, withPercentageWidth: 0.5, withValidation: lastNameValidation)
            formController.addField(YFField(name: "email", placeHolder: "Email"), inSection: i, withPercentageWidth: 1, withValidation: validation)
        }
        formController.setSectionTitles("Person")
        
        // Add to view controller
        self.addChildViewController(formController)
        self.view.addSubview(formController.view!)
        formController.view!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[view]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view":formController.view!]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(70)-[form]-(80)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["form": formController.view!]))
        
        submitButton.layer.cornerRadius = 8
    }
    
    // MARK: YFormDelegate
    
    func formController(formController: YFormController, updatedField field: YFBasicField, atIndexPath indexPath: NSIndexPath) {
        let person = persons[indexPath.section]
        switch field.name {
        case "firstName":
            person.firstName = field.text
        case "lastName":
            person.lastName = field.text
        default:
            break
        }
    }
    
    // MARK: Actions

    @IBAction func actionSubmitData(sender: AnyObject) {
        if formController.validateFields() {
            performSegueWithIdentifier(MainViewController.seguePushEnd, sender: self)
        }
    }
}

class Person: NSObject {
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    
}