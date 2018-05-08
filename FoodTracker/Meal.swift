//
//  Meal.swift
//  West Point Meal Rater
//
//  Created by Spencer Welton, Ryan Wilson, and Andre Hufnagel on 14APR2018.
//  Copyright © 2018 PrideLand Tech. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var review: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let review  = "review"
    }
    
    
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
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        self.review = review
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(review, forKey: PropertyKey.review)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //THis name is required. It should fail if we cannot decode a name string
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name of the meal object", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is optional property of meal, ust use condtional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        let review = aDecoder.decodeObject(forKey:PropertyKey.review)
        
        //call designated initializer
        self.init(name: name, photo: photo, rating: rating, review: review as! String)
    }
    
    
    
    
}
