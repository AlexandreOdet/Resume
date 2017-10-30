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

class SkillsCollectionViewController: UIViewController {
  private let maxValue = 80
  private let reuseIdentifier = "SkillCell"
  private let disposeBag = DisposeBag()
  
  var skills = [Skill]()
  var collectionView: UICollectionView!
  
  var viewModel: SkillsViewModel!
  
  deinit {
    viewModel.cancelRequest()
  }
  
  init() {
    super.init(nibName: nil, bundle: Bundle.main)
    viewModel = SkillsViewModel()
    viewModel.fetchData()
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

  func setUpBindings() {
    viewModel.observableSkills
      .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: SkillsCollectionViewCell.self))
      { _, element, cell in
      cell.set(name: element.name)
      cell.set(percentage: element.percentage)
    }.disposed(by: disposeBag)
  }
  
}
