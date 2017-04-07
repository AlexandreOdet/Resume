//
//  PlistUtils.swift
//  Resume
//
//  Created by Odet Alexandre on 06/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

class PlistUtils {
  static func getGithubUrl() -> String? {
    let path = Bundle.main.path(forResource: "Network", ofType: "plist")
    guard let dict = NSDictionary(contentsOfFile: path!) else {
      return nil
    }
    return (dict.object(forKey: "github_url") as? String)
  }
}
