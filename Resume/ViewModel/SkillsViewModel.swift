//
//  SkillsViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 24/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class SkillsViewModel: ViewModelProtocol {
  
  lazy var disposeBag = DisposeBag()
  
  var apiCommunication = WebsiteAPICommunication()
  
  var skillsItems =  Variable<[Skill]>([])
  
  var observableSkills: Observable<[Skill]> {
    return skillsItems
      .asObservable()
      .catchErrorJustReturn([])
  }
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  func fetchData() {
    apiCommunication.fetchData().subscribe( { [weak self] event in
      guard let `self` = self else { return }
      switch event {
      case .next(var data):
        self.skillsItems.value.removeAll()
        data = data.sorted(by: { $0.name < $1.name })
        self.skillsItems.value.append(contentsOf: data)
      case .error(let error):
        print("\(error)")
        return
      case .completed:
        return
      }
    }).disposed(by: disposeBag)
  }
  
}
