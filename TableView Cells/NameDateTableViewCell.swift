//
//  NameDateTableViewCell.swift
//  List
//
//  Created by edan yachdav on 3/14/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class NameDateTableViewCell: UITableViewCell {

    @IBOutlet weak var todoDueDateTextField: UIDatePicker!
    @IBOutlet weak var todoNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
