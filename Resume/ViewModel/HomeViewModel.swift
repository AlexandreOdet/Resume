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

final class HomeViewModel: ViewModelProtocol {
  
  private let apiCommunication = WebsiteAPICommunication()
  private let disposeBag = DisposeBag()
  
  var studies = Variable<[Study]>([])
  
  var networkError: PublishSubject<Error> = PublishSubject()
  var shouldLoadData: PublishSubject<Bool> = PublishSubject()
  
  init() {
    shouldLoadData.subscribe(onNext: {
      [unowned self] shouldLoad in
      if shouldLoad { self.fetchData() }
      }, onCompleted: {
        self.cancelRequest()
    }).disposed(by: disposeBag)
  }
  
  internal func fetchData() {
    NetworkUtils.spinner.start()
    apiCommunication.fetchStudies().subscribe({ [weak self] event in
      guard let `self` = self else { return }
      NetworkUtils.spinner.stop()
      switch event {
      case .next(let data):
        if data.isEmpty {
          self.networkError.onNext(ResumeError.network)
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
  
  internal func cancelRequest() {
    apiCommunication.cancelRequest()
  }
}
