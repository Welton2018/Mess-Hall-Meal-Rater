//
//  MealViewController.swift
//  West Point Meal Rater
//
//  Created by Spencer Welton, Ryan Wilson, and Andre Hufnagel on 14APR2018.
//  Copyright © 2018 PrideLand Tech. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var reviewTextView: UITextView!
    
    /*
 This value is either passed by 'MealTableViewController' in
 'prepare(for: sender:)'
 or constructed as part of adding a new meal
 */
    var meal: Meal?
    var placeHolderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle th text field's user input through delegate callbacks.
        nameTextField.delegate = self
        reviewTextView.delegate = self      //Added by SW 30APR18
        
        //placeHolderLabel = UILabel()
        placeHolderLabel.text = "Enter review here..."
        placeHolderLabel.font = UIFont.italicSystemFont(ofSize: (reviewTextView.font?.pointSize)!)
        placeHolderLabel.sizeToFit()
        reviewTextView.addSubview(placeHolderLabel)
        placeHolderLabel.frame.origin = CGPoint(x: 5, y: (reviewTextView.font?.pointSize)! / 2)
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.isHidden = !reviewTextView.text.isEmpty
        // Used this website to learn how to add default placement text to help
        // instruct the user. 07MAY2018
        //
        
        
        // Set up view if editing the existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
            reviewTextView.text = meal.review      //Added by SW 30APR18
        }
        
        // Enable the Save button only if the text filed has a valid meal name
        //updateSaveButtonState()
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if placeHolderLabel.textColor == UIColor.lightGray {
            placeHolderLabel.text = ""
            reviewTextView.textColor = UIColor.yellow
        }
    }
    
    //MARK:  UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        navigationItem.title = textField.text
        //reviewTextField.text = textField.text     //Added by SW 30APR18
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button while editing
        saveButton.isEnabled = true
        placeHolderLabel.isHidden = !reviewTextView.text.isEmpty
    }
    
    
    //MARK: UIIMagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dimsmiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageViewer to display the selected image.
        photoImageView.image = selectedImage
        
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    
    // This method lets you configure a view controller before its presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        guard let button = sender  as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let review = reviewTextView.text ?? ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue
            meal = Meal(name: name, photo: photo, rating: rating, review: review)
    }
    
    
    // Exit the keyboard while editing
    //https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
    // Used this website to figure out how to implement a UITextView and how to hide the
    // keyboard when done with it. 07MAY2018
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
 
    //MARK: Private Methods
    
    /*
    private func updateSaveButtonState() {
        // Disable save button if the text field is empty
        let text = nameTextField.text ?? ""
        let textR = reviewTextView.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        saveButton.isEnabled = !textR.isEmpty   //Added by SW 30APR18
    }
    */
}



// We used the "Jump Right In" app tutorial for the basis of the app we were trying
//      to create. It gave us our basic structure as well as walked us through the
//      the beginnigs of creating our own app. With its help we were able to take what
//      was created and add our own spin to meet our initial project goal. The website
//      we used was:
//      https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/
//      24APR2018
