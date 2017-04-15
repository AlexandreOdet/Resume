//
//  HTTPRouter.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

enum HTTPRouter {
  static var baseUrl = AppConstant.network.websiteUrl
  static var jsonExt = AppConstant.network.jsonExtension
  
  case skills
  case experiences
  case studies
  
  var url: String {
    let path: String = {
      switch self {
      case .experiences:
        return "/experiences"
      case .skills:
        return "/competences"
      case .studies:
        return "/studies"
      }
    }()
    return (HTTPRouter.baseUrl!.appending(path).appending(HTTPRouter.jsonExt))
  }
}
