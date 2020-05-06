//
//  DetailsViewController.swift
//  Test Task
//
//  Created by Anton on 5/6/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

  
  var kittyDetails: KittyData?
  
  @IBOutlet weak var imgView: UIImageView!
  
  
  @IBOutlet weak var nameLbl: UILabel!
  
  @IBOutlet weak var originLbl: UILabel!
  
  @IBOutlet weak var idLbl: UILabel!
  
  @IBOutlet weak var temperamentLbl: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    nameLbl.text = kittyDetails?.name
    originLbl.text = kittyDetails?.origin
    idLbl.text = kittyDetails?.id
    temperamentLbl.text = kittyDetails?.temperament
    
    temperamentLbl.adjustsFontSizeToFitWidth = true
    temperamentLbl.sizeToFit()
//    temperamentLbl.minimumScaleFactor = 1
    temperamentLbl.numberOfLines = 0
//    temperamentLbl.lineBreakMode = .byWordWrapping
      
    }
    

  

}
