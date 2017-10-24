//
//  SkillsViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 24/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class SkillsViewModel {
  
  var apiCommunication = WebsiteAPICommunication()
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
}
