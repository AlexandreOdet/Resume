//
//  BaseAPICommunication.swift
//  Resume
//
//  Created by Odet Alexandre on 24/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPICommunication {
  var request: Alamofire.Request?
  
  func cancelRequest() {
    request.cancel()
  }
}
