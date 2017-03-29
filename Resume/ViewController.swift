//
//  ViewController.swift
//  Resume
//
//  Created by Odet Alexandre on 29/03/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  private let profileImage = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setUpView() {
    self.view.backgroundColor = UIColor.black
    self.view.addSubview(profileImage)
    profileImage.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.view).offset(20)
      make.centerX.equalTo(self.view)
      make.size.equalTo(200)
    }
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    profileImage.image = R.image.profile()
  }

}

