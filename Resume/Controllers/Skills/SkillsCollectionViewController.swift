//
//  SkillsCollectionViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SkillsCollectionViewController: UIViewController {
  private let maxValue = 80
  private let reuseIdentifier = "SkillCell"
  private let disposeBag = DisposeBag()
  
  var collectionView: UICollectionView!
  
  var viewModel: SkillsViewModel!
  
  deinit {
    viewModel.shouldLoadData.onCompleted()
  }
  
  init() {
    super.init(nibName: nil, bundle: Bundle.main)
    viewModel = SkillsViewModel()
    viewModel.shouldLoadData.onNext(true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) / 2, height: 150)
    layout.scrollDirection = .vertical
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.register(SkillsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = UIColor.veryLightGray
    setUpBindings()
  }
}

extension SkillsCollectionViewController: Bindable {
  func setUpBindings() {
    viewModel
      .skillsItems
      .observeOn(MainScheduler.instance)
      .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: SkillsCollectionViewCell.self))
      { _, element, cell in
        cell.set(name: element.name)
        cell.set(percentage: element.percentage)
      }.disposed(by: disposeBag)
    
    viewModel.error.asDriver(onErrorJustReturn: ResumeError.unknown).drive(onNext: { [weak self] _ in
      guard let `self` = self else { return }
      self.displayNetworkErrorAlert()
    }).disposed(by: disposeBag)
  }
}

extension SkillsCollectionViewController: Alertable {
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
