//
//  ProjectViewModel.swift
//  Resume
//
//  Created by Odet Alexandre on 24/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectViewModel: ViewModelProtocol {
  
  lazy var disposeBag = DisposeBag()
  
  private let apiCommunication = GithubAPICommunication()
  
  var items = Variable<[GithubProject]>([])
  
  var sortType: PublishSubject<SortType> = PublishSubject()
  
  var shouldLoadData: PublishSubject<Bool> = PublishSubject()
  
  var requestFailure: PublishSubject<Error> = PublishSubject()
  
  var observableItems: Observable<[GithubProject]> {
    return items
      .asObservable()
      .catchErrorJustReturn([])
  }
  
  init() {
    sortType.subscribe(onNext: {
      [unowned self] type in
      self.sort(by: type)
      }).disposed(by: disposeBag)
    
    shouldLoadData.subscribe(onNext: {
      [unowned self] shouldLoad in
      if shouldLoad { self.fetchData() }
      }, onCompleted: {
        self.cancelRequest()
    }).disposed(by: disposeBag)
    
  }
  
  internal func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  internal func fetchData() {
    NetworkUtils.spinner.start()
    apiCommunication.fetchProjects().subscribe({ [weak self] event -> Void in
      NetworkUtils.spinner.stop()
      guard let `self` = self else { return }
      switch event {
      case .next(let projects):
        if projects.isEmpty {
          self.requestFailure.onNext(ResumeError.network)
        } else {
          if !self.items.value.isEmpty {
            self.items.value.removeAll()
          }
          self.items.value.append(contentsOf: projects)
        }
      case .completed:
        return
      case .error(let error):
        self.requestFailure.onNext(error)
      }
    }).disposed(by: disposeBag)
  }
  
  private func sort(by type: SortType) {
    switch type {
    case .ascOrder:
      items.value = items.value.sorted(by: { $0.projectName < $1.projectName })
    case .descOrder:
      items.value = items.value.sorted(by: { $0.projectName > $1.projectName })
    case .langage:
      items.value = items.value.sorted(by: {$0.language < $1.language })
    }
  }
}
