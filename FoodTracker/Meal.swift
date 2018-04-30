//
//  Meal.swift
//  FoodTracker
//
//  Created by Spencer Welton on 11/6/17.
//  Copyright © 2017 PrideLand Tech. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var review: String
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, review: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stroed properties
        self.name = name
        self.photo = photo
        self.rating = rating
        self.review = review
    }
    
    
}
