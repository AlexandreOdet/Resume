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
import CircleProgressBar

class SkillsCollectionViewController: UIViewController {
  private let websiteApiCommunication = WebsiteAPICommunication()
  private let maxValue = 80
  var skills = [Skill]()
  var circularProgressBar = CircleProgressBar()
  var collectionView = UICollectionView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Change any of the properties you'd like
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(circularProgressBar)
    circularProgressBar.progressBarTrackColor = UIColor.lightGray
    circularProgressBar.progressBarProgressColor = UIColor.red
    circularProgressBar.startAngle = -90
    circularProgressBar.hintTextColor = UIColor.black
    circularProgressBar.backgroundColor = UIColor.white
    circularProgressBar.snp.makeConstraints { (make) -> Void in
      make.center.equalTo(self.view)
      make.size.equalTo(240)
    }
    fetchData()
  }
  
  private func fetchData() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    firstly {
      websiteApiCommunication.fetchSkills()
      }.then { array -> Void in
        self.skills.append(contentsOf: array)
        self.circularProgressBar.setProgress(CGFloat(self.skills[0].percentage) / 100, animated: true)
      }.catch { error in
        let alertError = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des données", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertError, animated: true, completion: nil)
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
}
