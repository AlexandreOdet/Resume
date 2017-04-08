//
//  GithubProjectsListTableViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 05/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import PromiseKit
import Alamofire


class GithubProjectListTableViewController: UITableViewController {
  
  var projects = [GithubProject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  private func fillArray() {
  
  }
}
