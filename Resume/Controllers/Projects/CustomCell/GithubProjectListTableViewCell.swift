//
//  GithubProjectListTableViewCell.swift
//  Resume
//
//  Created by Odet Alexandre on 19/04/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class GithubProjectListTableViewCell: UITableViewCell {
  var labelNameProject = UILabel()
  var labelDescriptionProject = UILabel()
  var labelProjectLanguage = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    self.contentView.addSubview(labelNameProject)
    labelNameProject.snp.makeConstraints { (make) -> Void in
      make.leading.equalTo(self.contentView).offset(10)
      make.bottom.equalTo(self.contentView.snp.centerY)
      make.trailing.equalTo(self.contentView).offset(-50)
    }
    labelNameProject.translatesAutoresizingMaskIntoConstraints = false
    
    self.contentView.addSubview(labelDescriptionProject)
    labelDescriptionProject.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView.snp.centerY).offset(2)
      make.leading.equalTo(self.contentView).offset(10)
      make.trailing.equalTo(self.contentView).offset(-70)
      make.bottom.equalTo(self.contentView).offset(-3)
    }
    labelDescriptionProject.translatesAutoresizingMaskIntoConstraints = false
    labelDescriptionProject.textColor = UIColor.lightGray
    labelDescriptionProject.font = labelDescriptionProject.font.withSize(12)
    
    self.contentView.addSubview(labelProjectLanguage)
    labelProjectLanguage.snp.makeConstraints { (make) -> Void in
      make.trailing.equalTo(self.contentView).offset(-5)
      make.centerY.equalTo(self.contentView)
    }
    labelProjectLanguage.translatesAutoresizingMaskIntoConstraints = false
    labelProjectLanguage.textColor = UIColor.darkGray
    labelProjectLanguage.font = labelProjectLanguage.font.withSize(15)
  }
  
}
