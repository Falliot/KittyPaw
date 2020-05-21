//
//  RandomImgViewController.swift
//  Test Task
//
//  Created by Anton on 5/18/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class RandomImgViewController: UIViewController {
  
  @IBOutlet weak var imgView: CustomImageView!
  
  @IBOutlet weak var refreshButton: UIButton!
  
  var utility = Utility()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Tap on kitty to view it full size"
    refreshButton.isHidden = true
    getImage()
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }
  
  @IBAction func refreshtButtonIsClicked(_ sender: Any) {
    getImage()
  }
  
  func getImage() {
    guard let resourceURL = URL(string: "https://api.thecatapi.com/v1/images/search") else { fatalError() }
    let urlRequest = URLRequest(url: resourceURL)
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      if error != nil {
        self.utility.alert(controller: self, message: "Error: \(String(describing: error))")
        print("Error occured: \(String(describing: error))")
        return
      }
      guard let safeData = data  else { return }
      do {
        let decodingData = try JSONDecoder().decode([BreedImg].self, from: safeData)
        
        DispatchQueue.main.async {
          self.imgView.downloadImage(urlString: decodingData.first!.url, completion: { result in
            switch result {
            case .success:
              self.refreshButton.isHidden = false
            case .failure(let error):
              self.utility.alert(controller: self, message: "Error: \(error)")
            }
          })
        }
        print("JSON data: \(decodingData)")
      } catch {
        print("Decoder error:  \(String(describing: error))")
      }
    }.resume()
  }
  
  @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
    navigationItem.title = ""
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
