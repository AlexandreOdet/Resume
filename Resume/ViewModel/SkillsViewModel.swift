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
  
  var skillsItems: Observable<[Skill]> {
    return apiCommunication.fetchSkills().flatMapLatest({ skills -> Observable<[Skill]> in
      return Observable.just(skills)
      .catchErrorJustReturn([])
      .filter({!$0.isEmpty })
      .observeOn(MainScheduler.instance)
    })
  }
  var error: PublishSubject<Error> = PublishSubject()
  var shouldLoadData: PublishSubject<Bool> = PublishSubject()

  init() {
    shouldLoadData.subscribe(onNext: {
      [unowned self] shouldLoad in
      if shouldLoad { self.skillsItems.retry() }
      }, onCompleted: {
        self.cancelRequest()
    }).disposed(by: disposeBag)
  }
  
  internal func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  internal func fetchData() {
  }
  
}
