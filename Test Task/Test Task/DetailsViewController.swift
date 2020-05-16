//
//  DetailsViewController.swift
//  Test Task
//
//  Created by Anton on 5/6/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
  
  
  var kittyDetails: BreedImg?
  
  @IBOutlet weak var imgView: CustomImageView!
  
  @IBOutlet weak var descriptionLbl: UILabel!
  
  @IBOutlet weak var weightLbl: UILabel!
  
  @IBOutlet weak var originLbl: UILabel!
  
  @IBOutlet weak var temperamentLbl: UILabel!
  
  @IBOutlet weak var wikiButton: UIBarButtonItem!

  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    title = kittyDetails?.breeds.first?.name
    descriptionLbl.text = kittyDetails?.breeds.first?.description
    originLbl.text = "From: " + (kittyDetails?.breeds.first!.origin)!
    weightLbl.text = "Weight " + (kittyDetails?.breeds.first?.weight.metric)! + " kg"
    
    temperamentLbl.text = kittyDetails?.breeds.first?.temperament
    
    textFixer(textLabel: descriptionLbl)
    textFixer(textLabel: temperamentLbl)
    
    
    
    if kittyDetails?.breeds.first?.id == "ebur" {
      wikiButton.isEnabled = false
    }
    
  }

  func textFixer(textLabel: UILabel) {
    textLabel.adjustsFontSizeToFitWidth = true
    textLabel.sizeToFit()
    textLabel.numberOfLines = 0
  }
  
  @IBAction func wikiButtonIsClicked(_ sender: Any) {
    let url = URL(string: (kittyDetails?.breeds.first!.wikipediaURL)!)
    if UIApplication.shared.canOpenURL(url!) {
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
  }
    
  @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
    let newImageView = UIImageView(image: imgView.image)
    newImageView.frame = UIScreen.main.bounds
    newImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    newImageView.contentMode = .scaleAspectFit
    newImageView.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
    newImageView.addGestureRecognizer(tap)
    self.view.addSubview(newImageView)
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.isHidden = true
  }
  
  @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
    self.navigationController?.isNavigationBarHidden = false
    self.tabBarController?.tabBar.isHidden = false
    sender.view?.removeFromSuperview()
  }
  
  
  
}
