//
//  AlertableProtocol.swift
//  Resume
//
//  Created by Odet Alexandre on 31/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

@objc protocol Alertable {
  @objc optional func displayPhoneCallErrorAlert()
  @objc optional func displayMailErrorAlert()
  func displayNetworkErrorAlert()
}
