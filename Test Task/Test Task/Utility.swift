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
  
  func downloadImage(urlString: String) {
      
    // setup activityIndicator...
    activityIndicator.style = .large
    activityIndicator.color = .darkGray

    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    
    
    imageUrlString = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    image = nil
    activityIndicator.startAnimating()
    
    if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
      self.image = imageFromCache
      activityIndicator.stopAnimating()
      return
    }
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
      
      if error != nil {
        print("Error occured during downloading: \(String(describing: error))")
        DispatchQueue.main.async {
         self.activityIndicator.stopAnimating()
        }
        return
      }
      
      DispatchQueue.main.async {
        
        if let imageToCache = UIImage(data: data!) {
        
        print("Success: \(urlString)")
        
        if self.imageUrlString == urlString {
          
          self.image = imageToCache
        }
          imageCache.setObject(imageToCache, forKey: urlString as NSString)
        }
        
        self.activityIndicator.stopAnimating()
      }
      
    }).resume()
  }  
}
