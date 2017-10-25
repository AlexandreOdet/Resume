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
  
  var studies = Variable<[Study]>([])
  
  var networkError: PublishSubject<Error> = PublishSubject()
  
  func fetchData() {
    apiCommunication.fetchStudies().subscribe({ [weak self] event in
      guard let `self` = self else { return }
      switch event {
      case .next(let data):
        if !self.studies.value.isEmpty {
          self.studies.value.removeAll()
        }
        self.studies.value.append(contentsOf: data)
      case .error(let error):
        self.networkError.onNext(error)
      case .completed:
        return
      }
    }).dispose()
  }
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
}
