//
//  MealTableViewCell.swift
//  West Point Meal Rater
//
//  Created by Spencer Welton, Ryan Wilson, and Andre Hufnagel on 14APR2018.
//  Copyright © 2018 PrideLand Tech. All rights reserved.

import UIKit

class MealTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
