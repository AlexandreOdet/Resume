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


final class SkillsViewModel: ViewModelProtocol {
  
  lazy var disposeBag = DisposeBag()
  
  private let apiCommunication = WebsiteAPICommunication()
  
  var skillsItems =  Variable<[Skill]>([])
  var error: PublishSubject<Error> = PublishSubject()
  var shouldLoadData: PublishSubject<Bool> = PublishSubject()
  
  var observableSkills: Observable<[Skill]> {
    return skillsItems
      .asObservable()
      .catchErrorJustReturn([])
  }

  init() {
    shouldLoadData.subscribe(onNext: {
      [unowned self] shouldLoad in
      (shouldLoad) ? self.fetchData() : self.cancelRequest()
    }).disposed(by: disposeBag)
  }
  
  internal func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  internal func fetchData() {
    NetworkUtils.spinner.start()
    apiCommunication.fetchSkills().subscribe( { [weak self] event in
      guard let `self` = self else { return }
      NetworkUtils.spinner.stop()
      switch event {
      case .next(let data):
        if data.isEmpty {
          self.error.onNext(ResumeError.network)
        } else {
          self.skillsItems.value.removeAll()
          self.skillsItems.value.append(contentsOf: data.sorted(by: { $0.name < $1.name }))
        }
      case .error(let error):
        self.error.onNext(error)
        return
      case .completed:
        return
      }
    }).disposed(by: disposeBag)
  }
  
}
