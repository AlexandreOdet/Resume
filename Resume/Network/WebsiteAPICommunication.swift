//
//  WebsiteAPICommunication.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import AlamofireObjectMapper

class WebsiteAPICommunication {
  
  func fetchSkills() -> Promise<[Skill]> {
    return Promise { (fulfill, reject) in
      Alamofire.request(HTTPRouter.skills.url, method: .get).responseArray(completionHandler: {
        (response: DataResponse<[Skill]>) in
        switch response.result {
        case .success(let array):
          fulfill(array)
        case .failure(let error):
          reject(error)
        }
      })
    }
  }
  
}
