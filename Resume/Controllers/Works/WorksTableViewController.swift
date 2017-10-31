//
//  WorksTableViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 30/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WorksTableViewController: UIViewController {
  
  private let viewModel = WorksViewModel()
  private let disposeBag = DisposeBag()
  private let reuseIdentifier = "WorkCell"
  
  var tableView: UITableView!
  
  deinit {
     viewModel.shouldLoadData.onNext(false)
  }
  
  init() {
    super.init(nibName: nil, bundle: Bundle.main)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView = UITableView(frame: view.frame, style: .grouped)
    tableView.register(WorksTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    setUpBindings()
    viewModel.shouldLoadData.onNext(true)
  }
}

extension WorksTableViewController: Bindable {
  func setUpBindings() {
    viewModel.requestFailure.asDriver(onErrorJustReturn: ResumeError.unknown).drive(onNext: { [weak self] _ in
      guard let `self` = self else { return }
      self.displayNetworkError()
    }).disposed(by: disposeBag)
    
    viewModel.works.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: WorksTableViewCell.self)) {
      _, element, cell in
      cell.textLabel?.text = element.entreprise!
      cell.detailTextLabel?.text = element.role!
    }.disposed(by: disposeBag)
  }
  
  func displayNetworkError() {
    let alert = UIAlertController(title: "Oops", message: "Il semble que quelque chose ce soit mal passé.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: {
      [unowned self] _ in
      self.viewModel.shouldLoadData.onNext(true)
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
