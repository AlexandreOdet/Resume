//
//  SkillsCollectionViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 15/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SnapKit

class SkillsCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  private let websiteApiCommunication = WebsiteAPICommunication()
  private let maxValue = 80
  private let reuseIdentifier = "SkillCell"

  var skills = [Skill]()
  var collectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Change any of the properties you'd like
    view.backgroundColor = UIColor.white
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) / 2, height: 150)
    layout.scrollDirection = .vertical
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(SkillsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    self.view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) -> Void in
      make.edges.equalTo(self.view)
    }
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = UIColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    fetchData()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return skills.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! SkillsCollectionViewCell
    cell.set(name: skills[indexPath.row].name)
    cell.set(percentage: skills[indexPath.row].percentage)
    return cell
  }
  
  private func fetchData() {
    NetworkUtils.spinner.start()
    firstly {
      websiteApiCommunication.fetchSkills()
      }.then { array -> Void in
        self.skills.append(contentsOf: array)
        self.skills.sort(by: { $0.name < $1.name })
        self.collectionView.reloadData()
      }.catch { error in
        let alertError = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des données", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertError, animated: true, completion: nil)
      }.always {
        NetworkUtils.spinner.stop()
    }
  }
}
