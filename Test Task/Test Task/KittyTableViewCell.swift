//
//  KittyTableViewCell.swift
//  Test Task
//
//  Created by Anton on 5/5/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

//MARK: Custom TableViewCell

class KittyTableViewCell: UITableViewCell {
  
  @IBOutlet weak var cellView: UIView!
  
  @IBOutlet weak var imgView: CustomImageView!
  
  @IBOutlet weak var nameLbl: UILabel!
  
  @IBOutlet weak var originLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
