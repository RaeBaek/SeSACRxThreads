//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 백래훈 on 11/3/23.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    
    let word = PublishSubject<String>() //BehaviorSubject(value: "")
    let buttonStatus = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        word
            .distinctUntilChanged() // 연달아 중복된 값이 올때 무시
            .map { $0.count >= 2 && $0.count < 6 }
            .subscribe(with: self) { object, value in
                print(value)
                object.buttonStatus.onNext(!value)
            }
            .disposed(by: disposeBag)
        
    }
    
}
