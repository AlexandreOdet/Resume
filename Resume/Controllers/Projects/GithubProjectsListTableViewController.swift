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
    tableView.isUserInteractionEnabled = false
    fetchDataFromGithub()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = GithubProjectListTableViewCell()
    cell.labelNameProject.text = projects[indexPath.row].projectName
    cell.labelDescriptionProject.text = projects[indexPath.row].description
    cell.labelProjectLanguage.text = projects[indexPath.row].language
    return cell
  }
  
  private func fetchDataFromGithub() {
    NetworkUtils.spinner.start()
    firstly {
      GithubAPICommunication.fetchProjects()
      }.then { array -> Void in
        self.projects.append(contentsOf: array)
        self.tableView.reloadData()
        self.setRightButtonItem()
      }.always {
        NetworkUtils.spinner.stop()
      }.catch { _ in
        let alertError = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des données", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertError, animated: true, completion: nil)
    }
  }
  
  func setRightButtonItem() {
    let item = UIBarButtonItem(image: R.image.order(), style: .plain, target: self, action: #selector(sortButtonTarget))
    self.navigationItem.rightBarButtonItem = item
  }
  
  func sortButtonTarget() {
    let alert = UIAlertController(title: "Trier par", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Ordre ascendant", style: .default, handler: {
      action in
      self.sortProjectArray(by: .ascOrder)
    }))
    alert.addAction(UIAlertAction(title: "Ordre descendant", style: .default, handler: {
      action in
      self.sortProjectArray(by: .descOrder)
    }))
    alert.addAction(UIAlertAction(title: "Langage", style: .default, handler: {
      action in
      self.sortProjectArray(by: .langage)
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func sortProjectArray(by sortType: SortType) {
    if sortType == .ascOrder {
      projects.sort(by: { $0.projectName < $1.projectName })
    } else if sortType == .descOrder {
      projects.sort(by: { $0.projectName > $1.projectName })
    } else if sortType == .langage {
      projects.sort(by: { $0.language < $1.language })
    }
    tableView.reloadData()
  }
  
}
