//
//  SkillsCollectionViewCell.swift
//  Resume
//
//  Created by Odet Alexandre on 22/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CircleProgressBar

class SkillsCollectionViewCell: UICollectionViewCell {
  private var skillNameLabel = UILabel()
  private var bottomView = UIView()
  private var circularProgressBar = CircleProgressBar()
  private let separator = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
    self.isUserInteractionEnabled = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    self.contentView.backgroundColor = UIColor.white
    self.contentView.addSubview(bottomView)
    bottomView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(self.contentView)
      make.height.equalTo(30)
      make.width.equalTo(self.contentView)
    }
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    bottomView.backgroundColor = UIColor.white
    
    contentView.addSubview(separator)
    separator.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(bottomView.snp.top)
      make.width.equalTo(self.contentView)
      make.height.equalTo(1)
    }
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = UIColor.lightGray
    
    self.contentView.addSubview(skillNameLabel)
    skillNameLabel.snp.makeConstraints { (make) -> Void in
      make.center.equalTo(bottomView)
    }
    skillNameLabel.translatesAutoresizingMaskIntoConstraints = false
    skillNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
    skillNameLabel.textColor = UIColor.darkGray
    skillNameLabel.textAlignment = .center
    
    contentView.addSubview(circularProgressBar)
    circularProgressBar.snp.makeConstraints { (make) -> Void in
      make.centerX.equalTo(contentView)
      make.centerY.equalTo(contentView).offset(-15)
      make.size.equalTo(100)
    }
    circularProgressBar.translatesAutoresizingMaskIntoConstraints = false
    circularProgressBar.backgroundColor = UIColor.clear
    circularProgressBar.progressBarTrackColor = UIColor.black
    circularProgressBar.progressBarProgressColor = UIColor.red
    circularProgressBar.startAngle = -90
    circularProgressBar.progressBarWidth = 5
    circularProgressBar.hintViewBackgroundColor = UIColor.clear
    circularProgressBar.hintTextColor = UIColor.black
  }
  
  func set(percentage: Int) {
    self.circularProgressBar.setProgress(CGFloat(percentage) / 100, animated: true)
  }
  
  func set(name: String) {
    self.skillNameLabel.text = name.uppercased()
  }
}
