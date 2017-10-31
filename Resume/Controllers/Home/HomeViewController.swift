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
import MessageUI

final class HomeViewController: UIViewController {
  
  private let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  private let disposeBag = DisposeBag()
  private let viewModel = HomeViewModel()
  private let localisation = "Toulouse, FR"
  
  private let reuseIdentifier = "HomeCollectionViewCell"
  
  var canSendMail: Variable<Bool> = Variable(true)
  var canMakeCall: Variable<Bool> = Variable(true)
  
  var collectionView: UICollectionView!
  
  deinit {
    viewModel.shouldLoadData.onNext(false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    setUpNavigationBarButtons()
    setUpBindings()
    setUpCollectionView()
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
    
    ageLabel.text = "\(year - 1993) ans"
    ageLabel.font = UIFont.boldSystemFont(ofSize: 15)
    ageLabel.textColor = UIColor.darkGray
    ageLabel.textAlignment = .center
    
    let localisationLabel = UILabel()
    let mailLabel = UILabel()
    
    view.addSubview(localisationLabel)
    localisationLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(nameLabel.snp.bottom).offset(10)
      make.leading.equalTo(nameLabel)
      make.trailing.equalTo(headerView.snp.centerX).offset(-5)
    }
    localisationLabel.text = localisation
    localisationLabel.adjustsFontSizeToFitWidth = true
    
    view.addSubview(mailLabel)
    mailLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(ageLabel.snp.bottom).offset(10)
      make.trailing.equalTo(ageLabel)
      make.leading.equalTo(headerView.snp.centerX).offset(5)
    }
    canSendMail.asObservable().bind(to: mailLabel.rx.isUserInteractionEnabled).disposed(by: disposeBag)
    
    mailLabel.text = "odet.alexandre.93@gmail.com"
    mailLabel.adjustsFontSizeToFitWidth = true
    
    let tapGesture = UITapGestureRecognizer()
    mailLabel.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event.bind(onNext: { recognizer in
      let mailViewController = MFMailComposeViewController()
      mailViewController.setToRecipients(["odet.alexandre.93@gmail.com"])
      mailViewController.setSubject("Contact depuis l'application Resume")
      mailViewController.setMessageBody("", isHTML: false)
      if MFMailComposeViewController.canSendMail() {
        self.present(mailViewController, animated: true, completion: nil)
      } else {
        self.displayCannotSendMailErrorAlert()
      }
    }).disposed(by: disposeBag)
    
    let phoneLabel = UILabel()
    view.addSubview(phoneLabel)
    phoneLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(mailLabel.snp.bottom).offset(10)
      make.trailing.equalTo(mailLabel)
      make.leading.equalTo(mailLabel)
    }
    phoneLabel.text = "07 87 68 69 21"
    phoneLabel.adjustsFontSizeToFitWidth = true
    
    let phoneGestureRecognizer = UITapGestureRecognizer()
    phoneLabel.addGestureRecognizer(phoneGestureRecognizer)
    
    phoneGestureRecognizer.rx.event.bind(onNext: { _ in
      if let url = URL(string: "tel://0787686921"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        self.displayCannotMakeCallAlert()
      }
    }).disposed(by: disposeBag)
    canMakeCall.asObservable().bind(to: phoneLabel.rx.isUserInteractionEnabled).disposed(by: disposeBag)
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
    viewModel.shouldLoadData.onNext(true)
    
    let width = UIScreen.main.bounds.width
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (width / 2) - 15, height: 90)
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.scrollDirection = .horizontal
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = UIColor.veryLightGray
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalToSuperview()
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(100)
    }

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
    
    let jobsLabel = UILabel()
    view.addSubview(jobsLabel)
    jobsLabel.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(collectionView.snp.top).offset(-10)
      make.width.equalToSuperview()
      make.height.equalTo(30)
    }
    jobsLabel.text = "Mes expériences professionnelles"
    jobsLabel.textAlignment = .center
    jobsLabel.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer()
    jobsLabel.addGestureRecognizer(tapGesture)
    tapGesture.rx.event.bind(onNext: {
      [unowned self] _ in
      let nextViewController = WorksTableViewController()
      self.navigationController?.pushViewController(nextViewController, animated: true)
    }).disposed(by: disposeBag)
  }
}

extension HomeViewController {
  func displayCannotSendMailErrorAlert() {
    let alert = UIAlertController(title: "Oops", message: "Seems like your device can't send e-mail !", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in
      self.canSendMail.value = false
    }))
    present(alert, animated: true, completion: nil)
  }
  
  func displayCannotMakeCallAlert() {
    let alert = UIAlertController(title: "Oops", message: "Seems like your device can't make a call !", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in
      self.canMakeCall.value = false
    }))
    present(alert, animated: true, completion: nil)
  }
  
  func showNetworkAlert() {
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

extension HomeViewController: Bindable {
  func setUpBindings() {
    viewModel.networkError.asDriver(onErrorJustReturn: ResumeError.unknown).drive(onNext: { [weak self] _ in
      guard let `self` = self else { return }
      self.showNetworkAlert()
    }).disposed(by: disposeBag)
  }
}

extension HomeViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}

