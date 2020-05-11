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
    
  @IBOutlet weak var nameLbl: UILabel!
  
  @IBOutlet weak var descriptionLbl: UILabel!
  
  @IBOutlet weak var originLbl: UILabel!
  
  @IBOutlet weak var temperamentLbl: UILabel!
  
  @IBOutlet weak var wikiButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    nameLbl.text = kittyDetails?.breeds.first?.name
    descriptionLbl.text = kittyDetails?.breeds.first?.description
    originLbl.text = "From: " + (kittyDetails?.breeds.first!.origin)!
    
    temperamentLbl.text = kittyDetails?.breeds.first?.temperament
        
    imgView.downloadImage(urlString: kittyDetails!.url)
    
    textFixer(textLabel: descriptionLbl)
    textFixer(textLabel: temperamentLbl)
//    temperamentLbl.adjustsFontSizeToFitWidth = true
//    temperamentLbl.sizeToFit()
//    temperamentLbl.numberOfLines = 0
    
    
    if kittyDetails?.breeds.first?.id == "ebur" {
      wikiButton.isEnabled = false
    }
    
  }
  
  func textFixer(textLabel: UILabel) {
    textLabel.adjustsFontSizeToFitWidth = true
    textLabel.sizeToFit()
    textLabel.numberOfLines = 0
  }
//  override func loadView() {
//    let webConfiguration = WKWebViewConfiguration()
//    webView = WKWebView(frame: .zero, configuration: webConfiguration)
//    webView.uiDelegate = self
//    view = webView
//  }
  
  
  @IBAction func wikiButtonIsClicked(_ sender: Any) {
    let url = URL(string: (kittyDetails?.breeds.first!.wikipediaURL)!)
//    let myRequest = URLRequest(url: myURL!)
//    webView.load(myRequest)
    if UIApplication.shared.canOpenURL(url!) {
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    
  }
}
