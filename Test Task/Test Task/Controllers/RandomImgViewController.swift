//
//  RandomImgViewController.swift
//  Test Task
//
//  Created by Anton on 5/18/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class RandomImgViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var imgView: CustomImageView!
  
  @IBOutlet weak var refreshButton: UIButton!
  
  var scrollView : UIScrollView!
  
  var newImageView = UIImageView()
  
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
  
  //MARK: Method for triggering refresh button
  
  @IBAction func refreshtButtonIsClicked(_ sender: Any) {
    getImage()
  }
  
  //MARK: Method for getting a random image
  
  func getImage() {
    guard let resourceURL = URL(string: "https://api.thecatapi.com/v1/images/search") else { fatalError() }
    let urlRequest = URLRequest(url: resourceURL)
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      if error != nil {
        self.utility.getError(error: error! as NSError, controller: self)
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
  
  //MARK: ScrollView
  
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
  
  //MARK: Display an image in full size
  
  @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
    navigationItem.title = ""
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
  
  //MARK: Method that allows zooming in scrollView
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.newImageView
  }
}
