//
//  Study.swift
//  Resume
//
//  Created by Odet Alexandre on 25/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class Study: Mappable {
  var id: Int!
  var school: String!
  var diploma: String?
  var begin: String!
  var end: String!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    school <- map["school"]
    diploma <- map["diploma"]
    begin <- map["begin"]
    end <- map["end"]
  }
}
