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
  
  var apiCommunication = GithubAPICommunication()
  
  var items = Variable<[GithubProject]>([])
  
  var observableItems: Observable<[GithubProject]> {
    return items
      .asObservable()
      .catchErrorJustReturn([])
  }
  
  func cancelRequest() {
    apiCommunication.cancelRequest()
  }
  
  func fetchData() {
    NetworkUtils.spinner.start()
    apiCommunication.fetchProjects().subscribe({ [weak self] event -> Void in
      NetworkUtils.spinner.stop()
      guard let `self` = self else { return }
      switch event {
      case .next(let projects):
        self.items.value.removeAll()
        self.items.value.append(contentsOf: projects)
      case .completed:
        return
      case .error(let error):
        print("\(error)")
        return
      }
    }).disposed(by: disposeBag)
  }
  
  func sort(by type: SortType) {
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
