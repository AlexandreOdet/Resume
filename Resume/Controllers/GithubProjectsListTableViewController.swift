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
  private let reuseIdentifier = "GithubProjectCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView = UITableView(frame: self.view.frame, style: .grouped)
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    self.title = "Mes projets"
    fillArray()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    cell.textLabel?.text = projects[indexPath.row].projectName
    return cell
  }
  
  private func fillArray() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    firstly {
      GithubAPICommunication.fetchProjects()
      }.then { array -> Void in
        self.projects.append(contentsOf: array)
        self.tableView.reloadData()
      }.always {
       UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }.catch { _ in
        let alertError = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des données", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertError, animated: true, completion: nil)
    }
  }
}
