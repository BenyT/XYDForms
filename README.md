# YForms
An easy way of creating forms in iOS

## Features

* Can be added to your view controller as a childViewController.
* Adding a field requires one line of code.
* Supports more than one field in the same row.
* Allows different sections with different fields.
* Validations can be added to each field.
* FormView will scroll up in cases where the selected field would be hidden by the keyboard.

## Examples

The repo includes the following demo projects that can be used as templates or for testing purposes
* YFormsDemo.xcodeproj

.add a screenshot here

## Basic Usage

Initialize the formController
```
  let formController = YFormController()
  formController.delegate = self
```

Feed it with data
```
var nameValidation = YFValidation(isMandatoryWithErrorMessage: "First name is mandatory", maxCharacters: 10)
formController.addField(YFField(name: "firstName", placeHolder: "First Name"), withValidation: nameValidation)
```

Add it to your view controller
```
self.addChildViewController(formController)
self.view.addSubview(formController.view!)
// Add constraints
```

Get data from the Form's delegate
```
func formController(formController: YFormController, updatedField field: YFBasicField, atIndexPath indexPath: NSIndexPath) {}
```

## Requirements

* iOS 7.0 or later.
* ARC memory management.
