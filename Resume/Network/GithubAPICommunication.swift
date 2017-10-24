//
//  GithubAPICommunication.swift
//  Resume
//
//  Created by Odet Alexandre on 07/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import AlamofireObjectMapper

class GithubAPICommunication {
  public class func fetchProjects() -> Promise<[GithubProject]> {
    return Promise { (fulfill, reject) in
      Alamofire.request(AppConstant.network.githubUrl!).responseArray(completionHandler: {
        (response: DataResponse<[GithubProject]>) in
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
