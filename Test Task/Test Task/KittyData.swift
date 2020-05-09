//
//  KittyData.swift
//  Test Task
//
//  Created by Anton on 5/5/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import Foundation
struct KittyData : Codable {
  
  let id: String
  //let name: String
  //let temperament: String
  //let origin: String
  //let imageData: ImageParams
  
  
//  init(id: String, name: String, temperament: String, origin: String)// imageData: ImageParams)
//  {
//    self.id = id
//    //    self.name = name
//    //    self.temperament = temperament
//    //    self.origin = origin
//    //    self.imageData = imageData
//  }
  
}

struct BreedImg: Codable {
  var breeds = [Breeds]()
  //  var id: String
  var url: String
  var width: Int
  var height: Int
  
  
//  init(breeds: [Breeds], url: String, width: Int, height: Int) {
//    self.breeds = breeds
//    self.url = url
//    self.width = width
//    self.height = height
//  }
  
}

struct Breeds: Codable {
  let id: String
  let name: String
  let temperament: String
  let origin: String
  let wikipediaURL: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case temperament
    case origin
    case wikipediaURL = "wikipedia_url"
  }
  
//  
//  init(id: String, name: String, temperament: String, origin: String, wiki: String)
//  {
//    self.id = id
//    self.name = name
//    self.temperament = temperament
//    self.origin = origin
//    self.wikipediaURL = wiki
//  }
}
