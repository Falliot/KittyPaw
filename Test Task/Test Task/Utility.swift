//
//  Utility.swift
//  Test Task
//
//  Created by Anton on 5/7/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
  
  var imageUrlString: String?
  
  let activityIndicator = UIActivityIndicatorView()
  
  func downloadImage(urlString: String, completion: @escaping(Result<String, Error>) -> Void) {
    
    activityIndicatorSetup()
    
    imageUrlString = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    image = nil
    DispatchQueue.main.async {
      self.activityIndicator.startAnimating()
    }
    
    if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
      self.image = imageFromCache
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
      }
      print("Image exists")
      return
    }
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
      
      if error != nil {
        completion(.failure(error!))
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
        }
        return
      }
      
      DispatchQueue.main.async {
        if let imageToCache = UIImage(data: data!) {
          if self.imageUrlString == urlString {
            self.image = imageToCache
          }
          imageCache.setObject(imageToCache, forKey: urlString as NSString)
        }
        completion(.success("Image is downloaded"))
        self.activityIndicator.stopAnimating()
      }
    }).resume()
    
  }
  
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }
  
  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
  
  
  
  
  func activityIndicatorSetup() {
    activityIndicator.style = .large
    activityIndicator.color = .darkGray
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
}

class Utility {
  
  func alert(controller: UIViewController, message: String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "KittyPaw", message:
        message , preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
      controller.present(alertController, animated: true, completion: nil)
    }
  }
  
  func getError(error: NSError, controller: UIViewController) {
    switch error.code {
    case -999:
      print("userCancel")
    default:
      print("EROROROROR")
      alert(controller: controller, message: "Error: \(error)")
    }
  }
  
}
