//
//  Work.swift
//  Resume
//
//  Created by Odet Alexandre on 30/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class Work: Mappable {
  var id: Int!
  var entreprise: String!
  var role: String!
  var description: String!
  var begin: String!
  var end: String!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    entreprise <- map["entreprise"]
    role <- map["role"]
    description <- map["description"]
    begin <- map["begin"]
    end <- map["end"]
  }
}
