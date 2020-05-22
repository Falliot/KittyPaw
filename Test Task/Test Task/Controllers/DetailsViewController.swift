//
//  DetailsViewController.swift
//  Test Task
//
//  Created by Anton on 5/6/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
  
  var kittyDetails: BreedImg?
  
  var utility = Utility()
  
  var scrollView : UIScrollView!
  
  var newImageView = UIImageView()
  
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
    
    DispatchQueue.main.async {
      self.imgView.downloadImage(urlString: self.kittyDetails!.url, completion: { result in
      switch result {
      case .success:
        print("\(String(describing: self.title)), image was loaded")
      case .failure(let error):
        self.utility.getError(error: error as NSError, controller: self)
      }
    })
    }
    if kittyDetails?.breeds.first?.id == "ebur" {
      wikiButton.isEnabled = false
    }
    
  }
  
  func textFixer(textLabel: UILabel) {
    textLabel.adjustsFontSizeToFitWidth = true
    textLabel.sizeToFit()
    textLabel.numberOfLines = 0
  }
  
  
   func setupScrollView() {
     scrollView=UIScrollView()
     scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
     scrollView.bounces=false
     let minScale = scrollView.frame.size.width / newImageView.frame.size.width;
     scrollView.minimumZoomScale = minScale
     scrollView.maximumZoomScale = 5.0
     scrollView.contentSize = newImageView.frame.size
     scrollView.delegate=self;
   }
  
  @IBAction func wikiButtonIsClicked(_ sender: Any) {
    let url = URL(string: (kittyDetails?.breeds.first!.wikipediaURL)!)
    if UIApplication.shared.canOpenURL(url!) {
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
  }
  
  @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
   self.navigationController?.isNavigationBarHidden = true
      newImageView = UIImageView(image: imgView.image)
      newImageView.frame = UIScreen.main.bounds
      newImageView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      newImageView.contentMode = .scaleAspectFit
      newImageView.isUserInteractionEnabled = true
      
      setupScrollView()
      
      self.view.addSubview(scrollView)
      let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
      scrollView.addGestureRecognizer(tap)
      scrollView.addSubview(newImageView)
      
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
      self.navigationController?.isNavigationBarHidden = false
      sender.view?.removeFromSuperview()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return self.newImageView
    }
}
