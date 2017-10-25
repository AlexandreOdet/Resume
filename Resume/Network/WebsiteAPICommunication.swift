//
//  WebsiteAPICommunication.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift
import RxCocoa

class WebsiteAPICommunication: BaseAPICommunication {
  func fetchSkills() -> Observable<[Skill]> {
    return Observable<[Skill]>
      .create({ observer -> Disposable in
        self.request = Alamofire.request(HTTPRouter.skills.url)
          .validate()
          .responseArray(completionHandler: {
            (response: DataResponse<[Skill]>) in
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
  
  func fetchStudies() -> Driver<[Study]> {
    return Driver.empty()
  }
}
