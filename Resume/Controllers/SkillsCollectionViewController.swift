//
//  SkillsCollectionViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class SkillsCollectionViewController: UIViewController {
  private let websiteApiCommunication = WebsiteAPICommunication()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  private func fetchData() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    firstly {
      websiteApiCommunication.fetchSkills()
      }.then { array -> Void in
        for item in array {
          print("name: \(item.name)\tpercentage: \(item.percentage)")
        }
      }.catch { error in
        print("\(error)")
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
}
