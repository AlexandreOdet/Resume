//
//  HomeViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 25/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelProtocol {
  
  private let apiCommunication = WebsiteAPICommunication()
  private let disposeBag = DisposeBag()
  
  var studies: Observable<[Study]> {
    return apiCommunication.fetchStudies().flatMapLatest({ studies -> Observable<[Study]> in
      return Observable.just(studies)
        .observeOn(MainScheduler.instance)
        .catchErrorJustReturn([])
    })
  }
  
  var observableName: Observable<String> {
    return Observable.just("Alexandre Odet")
  }
  
  var observableLocation: Observable<String> {
    return Observable.just("Toulouse, FR")
  }
  
  var observableAge: Observable<String> {
    let now = Date()
    let year = Calendar.current.component(.year, from: now)
    return Observable.just("\(year - 1993) ans")
  }
  
  var observableMail: Observable<String> {
    return Observable.just("odet.alexandre.93@gmail.com")
  }
  
  var observablePhone: Observable<String> {
    return Observable.just("07 87 68 69 21")
  }
  
  var canMakeCall = Variable<Bool>(true)
  var canSendEmail = Variable<Bool>(true)
  
  
  var networkError: PublishSubject<Error> = PublishSubject()
  var shouldLoadData: PublishSubject<Bool> = PublishSubject()
  var shouldUpdateCallValue: PublishSubject<Bool> = PublishSubject()
  var shouldUpdateEmailValue: PublishSubject<Bool> = PublishSubject()
  
  init() {
    shouldLoadData.subscribe(onNext: {
      [unowned self] shouldLoad in
      if shouldLoad { self.fetchData() }
      }, onCompleted: {
        self.cancelRequest()
    }).disposed(by: disposeBag)
    
    shouldUpdateCallValue.subscribe(onNext: {
      [unowned self] callAvailability in
      self.canMakeCall.value = callAvailability
    }).disposed(by: disposeBag)
    
    shouldUpdateEmailValue.subscribe(onNext: {
      [unowned self] availability in
      self.canSendEmail.value = availability
    }).disposed(by: disposeBag)
  }
  
  internal func fetchData() {
  }
  
  internal func cancelRequest() {
    apiCommunication.cancelRequest()
  }
}
