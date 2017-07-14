//
//  RhymeTableViewCell.swift
//  Lyrica
//
//  Created by Nathan Lewis on 7/13/17.
//  Copyright © 2017 Nathan Lewis. All rights reserved.
//

import UIKit

class RhymeTableViewCell: UITableViewCell {

    @IBOutlet weak var syllablesTitle: UILabel!
    @IBOutlet weak var rhymingWords: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
