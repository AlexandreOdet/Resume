//
//  ViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 29/03/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {
  
  private let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  private let disposeBag = DisposeBag()
  private let viewModel = HomeViewModel()
  
  private let reuseIdentifier = "HomeCollectionViewCell"
  
  var collectionView: UICollectionView!
  
  deinit {
    viewModel.cancelRequest()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    setUpNavigationBarButtons()
    setUpBindings()
    setUpCollectionView()
  }
  
  func setUpBindings() {
    viewModel.networkError.asDriver(onErrorJustReturn: ResumeError.unknownError).drive(onNext: { [weak self] _ in
      guard let `self` = self else { return }
      self.showNetworkAlert()
    }).disposed(by: disposeBag)
  }
  
  func showNetworkAlert() {
    let alert = UIAlertController(title: "Erreur", message: "Oups ! Il semble que quelque chose se soit mal passé :(.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: {
      [weak self] _ in
      guard let `self` = self else { return }
      self.viewModel.fetchData()
    }))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func setUpView() {
    view.backgroundColor = UIColor.black
    
    let background = UIImageView()
    background.image = UIImage(named: "wallpaper")
    view.addSubview(background)
    background.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    
    view.addSubview(profileImage)
    profileImage.snp.makeConstraints { (make) -> Void in
      make.top.equalToSuperview().offset(80)
      make.centerX.equalToSuperview()
      make.size.equalTo(100)
    }
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    profileImage.image = UIImage(named: "profile")
    profileImage.round()
    
    addHeaderView()
  }
  
  private func addHeaderView() {
    let headerView = UIView()
    view.addSubview(headerView)
    headerView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(profileImage.snp.bottom).offset((80 - ((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height)))
      make.width.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    headerView.translatesAutoresizingMaskIntoConstraints = false
    headerView.backgroundColor = UIColor.white
    
    let nameLabel = UILabel()
    headerView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalToSuperview().offset(5)
      make.leading.equalToSuperview().offset(10)
    }
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = "Alexandre Odet"
    nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
    nameLabel.textColor = UIColor.darkGray
    
    let ageLabel = UILabel()
    headerView.addSubview(ageLabel)
    ageLabel.snp.makeConstraints { (make) -> Void in
      make.trailing.equalToSuperview().offset(-10)
      make.top.equalTo(nameLabel)
    }
    ageLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let now = Date()
    let year = Calendar.current.component(.year, from: now)
    
    ageLabel.text = "\(getDifferenceBetweenTwoYears(begin: 1993, end: year)) ans"
    ageLabel.font = UIFont.boldSystemFont(ofSize: 15)
    ageLabel.textColor = UIColor.darkGray
    ageLabel.textAlignment = .center
    
  }
  
  private func getDifferenceBetweenTwoYears(begin: Int, end: Int) -> Int {
    return end - begin
  }
  
  private func setUpNavigationBarButtons() {
    let rightButton = UIBarButtonItem(title: "Mes compétences",
                                      style: .plain, target: self,
                                      action: nil)

    rightButton.rx.tap.subscribe(onNext: { [unowned self] in
      let nextViewController = SkillsCollectionViewController()
      self.navigationController?.pushViewController(nextViewController, animated: true)
    }).disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem  = rightButton
    
    
    let leftButton = UIBarButtonItem(title: "Mes projets",
                                     style: .plain, target: self,
                                     action: nil)
    
    leftButton.rx.tap.subscribe(onNext: { [unowned self] in
      let nextViewController = GithubProjectListTableViewController()
      self.navigationController?.pushViewController(nextViewController, animated: true)
    }).disposed(by: disposeBag)
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  private func setUpCollectionView() {
    viewModel.fetchData()
    let width = UIScreen.main.bounds.width
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (width / 2) - 15, height: 90)
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.scrollDirection = .horizontal
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.showsHorizontalScrollIndicator = false
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalToSuperview()
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(100)
    }
    collectionView.backgroundColor = UIColor.veryLightGray
    viewModel.studies.asObservable()
      .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: HomeCollectionViewCell.self)) {
        row, element, cell in
        cell.backgroundColor = .white
        cell.schoolNameLabel.text = element.school
        if let diploma = element.diploma {
          if !diploma.isEmpty {
            cell.diplomaLabel.text = diploma
          } else {
            cell.diplomaLabel.text = "Pas de diplome"
          }
        } else {
          cell.diplomaLabel.text = "Pas de diplome"
        }
        cell.datesLabel.text = "Du \(element.begin!)  au \(element.end!)"
    }.disposed(by: disposeBag)
  }
  
}

