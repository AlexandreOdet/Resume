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
  
  var studies: Driver<[Study]> {
    return apiCommunication.fetchStudies()
  }
  
  func fetchData() {
  }
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
}
