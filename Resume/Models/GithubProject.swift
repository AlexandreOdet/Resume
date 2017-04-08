//
//  GithubProject.swift
//  Resume
//
//  Created by Odet Alexandre on 05/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class GithubProject: Mappable {
  var projectName = ""
  var description = ""
  var language = ""
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    self.projectName <- map["name"]
    self.description <- map["description"]
    self.language <- map["language"]
  }
}
