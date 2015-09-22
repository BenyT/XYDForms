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
        let emailRegexValidation = YFRegexValidation(regex: emailRegex, errorMessage: "Email is not valid")
        let emailValidation = XYDValidation(isMandatoryWithErrorMessage: "Email is mandatory", regexValidations: [emailRegexValidation])
        let nameValidation = XYDValidation(isMandatoryWithErrorMessage: "First name is mandatory", maxCharacters: 10)
        let lastNameValidation = XYDValidation(isMandatoryWithErrorMessage: "Last name is mandatory", maxCharacters: 10)
                
        // Fields setup
        persons = [Person(), Person(), Person(), Person(), Person(), Person(), Person(), Person(), Person(), Person(), Person(), Person()]
        formController = YFormController()
        formController.delegate = self
        for i in 0..<persons.count {
            
            let firstNameField = XYDTextField(identifier: "firstName", placeHolder: "First Name")
            firstNameField.percentageWidth = 0.5
            firstNameField.validation = nameValidation
            formController.addField(firstNameField, inSection: i)
            
            let lastNameField = XYDTextField(identifier: "lastName", placeHolder: "Last Name")
            lastNameField.percentageWidth = 0.5
            lastNameField.validation = lastNameValidation
            formController.addField(lastNameField, inSection: i)
    
            // Using selectors
            let emailField = XYDTextField(identifier: "email", placeHolder: "email")
            emailField.validation = emailValidation
            
            formController.addField(emailField, inSection: i, showSelector: { () -> () in
                self.formController.setText("defaultemail\(i + 1)@gmail.com", inFieldWithIdentifier: "email", inSection: i)
            })
        }
        formController.setSectionTitles("Person")
        
        // Add to view controller
        self.addChildViewController(formController)
        self.view.addSubview(formController.view!)
        formController.view!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[form]-(0)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["form": formController.view!]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(70)-[form]-(80)-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["form": formController.view!]))
                
        submitButton.layer.cornerRadius = 8
    }
    
    // MARK: YFormDelegate
    
    func formController(formController: YFormController, updatedField field: XYDField, atIndexPath indexPath: XYZIndexPath) {
        let person = persons[indexPath.1]
        switch field.identifier {
        case "firstName":
            person.firstName = field.value as! String
        case "lastName":
            person.lastName = field.value as! String
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