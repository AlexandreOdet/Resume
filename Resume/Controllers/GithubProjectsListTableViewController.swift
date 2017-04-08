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
    fillArray()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  private func fillArray() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    firstly {
      GithubAPICommunication.fetchProjects()
      }.then { array -> Void in
        self.projects.append(contentsOf: array)
      }.always {
       UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }.catch { _ in
        let alertError = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des données", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertError, animated: true, completion: nil)
    }
  }
}
