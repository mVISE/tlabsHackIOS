//
//  QuestionTableViewCell.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var questionSwitch: UISwitch!
  
  var questionID: String?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
