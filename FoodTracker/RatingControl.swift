//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Spencer Welton on 11/6/17.
//  Copyright © 2017 PrideLand Tech. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonsSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 60.0, height: 60.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected direwolf represents the current rating, reset the rating to 0
            rating = 0
        } else {
            // Otherwise set the rating to the selected direwolf
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledDirewolf = UIImage(named: "filledDirewolf", in: bundle, compatibleWith: self.traitCollection)
        let emptyDirewolf = UIImage(named:"emptyDirewolf", in: bundle, compatibleWith: self.traitCollection)
        let highlightedDirewolf = UIImage(named:"highlightedDirewolf", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyDirewolf, for: .normal)
            button.setImage(filledDirewolf, for: .selected)
            button.setImage(highlightedDirewolf, for: .highlighted)
            button.setImage(highlightedDirewolf, for: [.highlighted, .selected])
            
            // Add Constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup the button action
            button.addTarget(self, action:#selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
        
            // Add the new button to the rating button aray
            ratingButtons.append(button)
        }
        
        updateButtonsSelectionStates()
        
    }
    
    private func updateButtonsSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected direwolf
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 Direwolf set."
            default:
                valueString = "\(rating) Direwolves set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

    
    
}
