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

final class GithubProjectListTableViewController: UIViewController {
  
  private let reuseIdentifier = "GithubProjectCell"
  private let disposeBag = DisposeBag()
  
  var viewModel: ProjectViewModel!
  
  var tableView: UITableView!
  
  deinit {
    viewModel.shouldLoadData.onNext(false)
  }
  
  init() {
    super.init(nibName: nil, bundle: Bundle.main)
    viewModel = ProjectViewModel()
    viewModel.shouldLoadData.onNext(true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpBindings()
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
      [unowned self] _ in
      self.viewModel.sortType.onNext(.ascOrder)
    }))
    alert.addAction(UIAlertAction(title: "Ordre descendant", style: .default, handler: {
      [unowned self] _ in
      self.viewModel.sortType.onNext(.descOrder)
    }))
    alert.addAction(UIAlertAction(title: "Langage", style: .default, handler: {
      [unowned self] _ in
      self.viewModel.sortType.onNext(.langage)
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

extension GithubProjectListTableViewController: Bindable {
  func setUpBindings() {
    viewModel.requestFailure
      .asDriver(onErrorJustReturn: ResumeError.unknown)
      .drive(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.displayNetworkErrorAlert()
      }).disposed(by: disposeBag)
  }
}

extension GithubProjectListTableViewController: Alertable {
  func displayNetworkErrorAlert() {
    let alert = UIAlertController(title: "Erreur", message: "Oups ! Il semble que quelque chose se soit mal passé :(.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: {
      [weak self] _ in
      guard let `self` = self else { return }
      self.viewModel.shouldLoadData.onNext(true)
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
