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
  
  @IBOutlet weak var imgView: UIImageView!
  
  var imageURL = String()
  
  @IBOutlet weak var nameLbl: UILabel!
  
  @IBOutlet weak var originLbl: UILabel!
  
  @IBOutlet weak var idLbl: UILabel!
  
  @IBOutlet weak var temperamentLbl: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    nameLbl.text = kittyDetails?.breeds.first?.name
    originLbl.text = kittyDetails?.breeds.first?.origin
    idLbl.text = kittyDetails?.breeds.first?.id
    temperamentLbl.text = kittyDetails?.breeds.first?.temperament
  
    let url = URL(string: imageURL)
    imgView.downloaded(from: url!)
    
    temperamentLbl.adjustsFontSizeToFitWidth = true
    temperamentLbl.sizeToFit()
    temperamentLbl.numberOfLines = 0
  }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

