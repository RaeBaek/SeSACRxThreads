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
    
    let inputYear = PublishSubject<Int>()
    let outputYear = PublishSubject<String>()
    
    let inputMonth = PublishSubject<Int>()
    let outputMonth = PublishSubject<String>()
    
    let inputDay = PublishSubject<Int>()
    let outputDay = PublishSubject<String>()
    
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
        
        inputYear
            .subscribe(with: self) { owner, value in
                owner.outputYear.onNext("\(value)년")
            }
            .disposed(by: disposeBag)
        
        inputMonth
            .subscribe(with: self) { owner, value in
                owner.outputMonth.onNext("\(value)월")
            }
            .disposed(by: disposeBag)
        
        inputDay
            .subscribe(with: self) { owner, value in
                owner.outputDay.onNext("\(value)일")
            }
            .disposed(by: disposeBag)
    }
    
}
