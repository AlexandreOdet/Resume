//
//  GithubAPICommunication.swift
//  Resume
//
//  Created by Odet Alexandre on 07/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

final class GithubAPICommunication: BaseAPICommunication {
  
  func fetchProjects() -> Observable<[GithubProject]> {
    return Observable<[GithubProject]>
      .create({ observer -> Disposable in
      self.request = Alamofire.request(AppConstant.network.githubUrl!)
        .validate()
        .responseArray(completionHandler: {
          (response: DataResponse<[GithubProject]>) in
          switch response.result {
          case .success(let projects):
            observer.onNext(projects)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(error)
          }
        })
        return Disposables.create(with: {
          self.request?.cancel()
        })
    })
  }
}
