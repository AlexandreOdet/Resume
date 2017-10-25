//
//  HomeCollectionViewCell.swift
//  Resume
//
//  Created by Odet Alexandre on 25/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
  
  var schoolNameLabel = UILabel()
  var diplomaLabel = UILabel()
  var datesLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    contentView.addSubview(schoolNameLabel)
    schoolNameLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalToSuperview().offset(10)
      make.width.equalToSuperview()
    }
    schoolNameLabel.textAlignment = .center
    schoolNameLabel.adjustsFontSizeToFitWidth = true
    
    contentView.addSubview(diplomaLabel)
    diplomaLabel.snp.makeConstraints { (make) -> Void in
      make.width.equalToSuperview()
      make.top.equalTo(schoolNameLabel.snp.bottom).offset(10)
    }
    diplomaLabel.textAlignment = .center
    diplomaLabel.adjustsFontSizeToFitWidth = true
    
    contentView.addSubview(datesLabel)
    datesLabel.snp.makeConstraints { (make) -> Void in
      make.width.equalToSuperview()
      make.bottom.equalToSuperview().offset(-10)
    }
    datesLabel.textAlignment = .center
    datesLabel.adjustsFontSizeToFitWidth = true
  }
  
}
