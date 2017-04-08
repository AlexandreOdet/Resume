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

class GithubAPICommunication {
  static func fetchProjects() -> Promise<[GithubProject]> {
    let q = DispatchQueue.global()
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    return Promise<[GithubProject]> {_,_ in firstly { _ in
      Alamofire.request(AppConstant.network.url!, method: .get).responseData()
      }.then(on: q) { data in
        print("\(data)")
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
}
