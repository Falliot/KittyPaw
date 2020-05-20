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
}

struct BreedImg: Codable {
  var breeds = [Breeds]()
  var url: String
  var width: Int
  var height: Int
}

struct Breeds: Codable {
  let weight : Weight
  let id: String
  let description: String
  let name: String
  let temperament: String
  let origin: String
  let wikipediaURL: String?
  
  enum CodingKeys: String, CodingKey {
    case weight
    case id
    case description
    case name
    case temperament
    case origin
    case wikipediaURL = "wikipedia_url"
  }
}

struct Weight: Codable {
  let imperial: String
  let metric: String
}
