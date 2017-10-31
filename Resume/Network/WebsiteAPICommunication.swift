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

final class WebsiteAPICommunication: BaseAPICommunication {
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
      }).catchErrorJustReturn([])
    .observeOn(MainScheduler.instance)
  }
  
  func fetchStudies() -> Observable<[Study]> {
    return Observable<[Study]>
      .create({ observer -> Disposable in
        self.request = Alamofire.request(HTTPRouter.studies.url)
          .validate()
          .responseArray(completionHandler: {
            (response: DataResponse<[Study]>) in
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
      }).catchErrorJustReturn([])
    .observeOn(MainScheduler.instance)
  }
  
  func fetchWorks() -> Observable<[Work]> {
    return Observable<[Work]>
      .create({ observer -> Disposable in
        self.request = Alamofire.request(HTTPRouter.works.url)
        .validate()
          .responseArray(completionHandler: {
            (response: DataResponse<[Work]>) in
            switch response.result {
            case .success(let works):
              observer.onNext(works)
              observer.onCompleted()
            case .failure(let error):
              observer.onError(error)
            }
          })
        return Disposables.create(with: {
          self.request?.cancel()
        })
      }).catchErrorJustReturn([])
      .observeOn(MainScheduler.instance)
  }
  
}
