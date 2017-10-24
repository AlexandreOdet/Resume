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

class HomeViewController: UIViewController {
  
  private let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    setUpNavigationBarButtons()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func setUpView() {
    self.view.backgroundColor = UIColor.black
    
    let background = UIImageView()
    //background.image = R.image.wallpaper()
    self.view.addSubview(background)
    background.snp.makeConstraints { (make) -> Void in
      make.edges.equalTo(self.view)
    }
    
    self.view.addSubview(profileImage)
    profileImage.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.view).offset(80)
      make.centerX.equalTo(self.view)
      make.size.equalTo(100)
    }
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    //profileImage.image = R.image.profile()
    profileImage.round()
    
    addHeaderView()
  }
  
  //offset = (80 - (self.navigationController.navigationBar.frame.height + UIApplication.shared.statusBar.frame.height))
  
  private func addHeaderView() {
    let headerView = UIView()
    self.view.addSubview(headerView)
    headerView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(profileImage.snp.bottom).offset((80 - ((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height)))
      make.width.equalTo(self.view)
      make.bottom.equalTo(self.view)
    }
    headerView.translatesAutoresizingMaskIntoConstraints = false
    headerView.backgroundColor = UIColor.white
    
    let nameLabel = UILabel()
    headerView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(headerView).offset(5)
      make.leading.equalTo(headerView).offset(10)
    }
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = "Alexandre Odet"
    nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
    nameLabel.textColor = UIColor.darkGray
    
    let ageLabel = UILabel()
    headerView.addSubview(ageLabel)
    ageLabel.snp.makeConstraints { (make) -> Void in
      make.trailing.equalTo(headerView).offset(-10)
      make.top.equalTo(nameLabel)
    }
    ageLabel.translatesAutoresizingMaskIntoConstraints = false
    ageLabel.text = "29/01/1993 (24ans)"
    ageLabel.font = UIFont.boldSystemFont(ofSize: 15)
    ageLabel.textColor = UIColor.darkGray
    
  }
  
  private func setUpNavigationBarButtons() {
    let rightButton = UIBarButtonItem(title: "Mes compétences",
                                      style: .plain, target: self,
                                      action: #selector(skillsButtonTarget))
    self.navigationItem.rightBarButtonItem  = rightButton
    
    
    let leftButton = UIBarButtonItem(title: "Mes projets",
                                     style: .plain, target: self,
                                     action: #selector(projectsButtonTarget))
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  func skillsButtonTarget() {
    let nextViewController = SkillsCollectionViewController()
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }
  
  func projectsButtonTarget() {
    let nextViewController = GithubProjectListTableViewController()
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }
  
}

