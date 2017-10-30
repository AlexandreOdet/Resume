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
import Alamofire
import RxSwift

class GithubProjectListTableViewController: UIViewController {
  
  private let reuseIdentifier = "GithubProjectCell"
  private let disposeBag = DisposeBag()
  
  var viewModel: ProjectViewModel!
  
  var tableView: UITableView!
  
  deinit {
    viewModel.cancelRequest()
  }
  
  init() {
    super.init(nibName: nil, bundle: Bundle.main)
    viewModel = ProjectViewModel()
    viewModel.fetchData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    setRightButtonItem()
  }
  
  private func setUpTableView() {
    tableView = UITableView(frame: view.frame, style: .grouped)
    tableView.register(GithubProjectListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    
    viewModel.observableItems.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier,
                                                          cellType: GithubProjectListTableViewCell.self)) {
      _, element, cell in
      cell.labelNameProject.text = element.projectName
      cell.labelDescriptionProject.text = element.description
      cell.labelProjectLanguage.text = element.language
      cell.selectionStyle = .none
    }.disposed(by: disposeBag)
  }
  
  private func setRightButtonItem() {
    let item = UIBarButtonItem(image: UIImage(named: "order"), style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = item
    navigationItem.rightBarButtonItem?.rx.tap.subscribe (onNext: { [unowned self] _ in
      self.sortButtonTarget()
    }).disposed(by: disposeBag)
  }
  
  func sortButtonTarget() {
    let alert = UIAlertController(title: "Trier par", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Ordre ascendant", style: .default, handler: {
      _ in
      self.viewModel.sort(by: .ascOrder)
    }))
    alert.addAction(UIAlertAction(title: "Ordre descendant", style: .default, handler: {
      _ in
      self.viewModel.sort(by: .descOrder)
    }))
    alert.addAction(UIAlertAction(title: "Langage", style: .default, handler: {
      _ in
      self.viewModel.sort(by: .langage)
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
