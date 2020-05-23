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
  
  //MARK: Method for downloading and caching images
  
  func downloadImage(urlString: String, completion: @escaping(Result<String, Error>) -> Void) {
    
    activityIndicatorSetup()
    
    imageUrlString = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("eb4517d5-865b-4e49-9b2f-96acfa53c0b2", forHTTPHeaderField: "x-api-key")
    
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
  
  //MARK: Activity Indicator
  
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
  
  //MARK: Pop up alert
  
  func alert(controller: UIViewController, message: String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "KittyPaw", message:
        message , preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
      controller.present(alertController, animated: true, completion: nil)
    }
  }
  
  //MARK: Errors
  
  func getError(error: NSError, controller: UIViewController) {
    switch error.code {
    case -999:
      print("userCancel")
    case -1001:
      alert(controller: controller, message: "The request timed out.")
    case -1005:
      //      alert(controller: controller, message: "The network connection was lost.")
      print("The network connection was lost.")
    case -1009:
      alert(controller: controller, message: "The Internet connection appears to be offline.")
    default:
      print("EROROROROR")
      alert(controller: controller, message: "Error: \(error)")
    }
  }
}
