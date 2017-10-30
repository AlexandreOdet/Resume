//
//  WorksViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 30/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WorksViewModel: ViewModelProtocol {
  
  private let apiCommunication = WebsiteAPICommunication()
  private let disposeBag = DisposeBag()
  
  var requestFailure: PublishSubject<Error> = PublishSubject()
  
  var works: Driver<[Work]> = Driver.empty()
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  func fetchData() {
    apiCommunication.fetchWorks().subscribe({ [weak self] event in
      guard let `self` = self else { return }
      switch event {
      case .next(let data):
        if data.isEmpty {
          self.requestFailure.onNext(ResumeError.networkError)
        } else {
          self.works = Driver.from(optional: data)
        }
      case .completed:
        return
      case .error(let error):
        self.requestFailure.onNext(error)
      }
    }).disposed(by: disposeBag)
  }
}
