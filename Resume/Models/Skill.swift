//
//  Skill.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

final class Skill: Mappable {
  var id = -1
  var name = ""
  var percentage = -1
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    self.id <- map["id"]
    self.name <- map["name"]
    self.percentage <- map["pourcentage"]
  }
}
