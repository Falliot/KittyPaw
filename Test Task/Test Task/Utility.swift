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
  
  func downloadImage(urlString: String) {
    
    imageUrlString = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
      self.image = imageFromCache
      return
    }
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
      
      if error != nil {
        print(error ?? "")
        return
      }
      
      DispatchQueue.main.async {
        guard let imageToCache = UIImage(data: data!) else { return }
        
        print("Success: \(urlString)")
        
        if self.imageUrlString == urlString {
          self.image = imageToCache
        }
        
        imageCache.setObject(imageToCache, forKey: urlString as NSString)
      }
      
    }).resume()
  }
  
}
