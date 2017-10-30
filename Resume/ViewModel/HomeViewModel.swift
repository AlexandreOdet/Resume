//
//  HomeViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 25/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelProtocol {
  
  private let apiCommunication = WebsiteAPICommunication()
  private let disposeBag = DisposeBag()
  
  var studies = Variable<[Study]>([])
  
  var networkError: PublishSubject<Error> = PublishSubject()
  
  func fetchData() {
    NetworkUtils.spinner.start()
    apiCommunication.fetchStudies().subscribe({ [weak self] event in
      guard let `self` = self else { return }
      NetworkUtils.spinner.stop()
      switch event {
      case .next(let data):
        if data.isEmpty {
          self.networkError.onNext(ResumeError.NetworkError)
        } else {
          if !self.studies.value.isEmpty {
            self.studies.value.removeAll()
          }
          self.studies.value.append(contentsOf: data)
        }
      case .error(let error):
        self.networkError.onNext(error)
      case .completed:
        return
      }
    }).disposed(by: disposeBag)
  }
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
}
