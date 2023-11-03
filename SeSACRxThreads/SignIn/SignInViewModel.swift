//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewModel {
    
    let isOn = BehaviorSubject(value: true) //BehaviorSubject(value: true) //Observable.of(true)
    let disposeBag = DisposeBag()
    
    init() {
        // RxSwift - 1
//        isOn
//            .subscribe { value in
//                print("일방적 동작?")
//                self.testSwitch.setOn(value, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        // RxSwift - 2
//        isOn
//            .bind(to: testSwitch.rx.isOn)
//            .disposed(by: disposeBag)
//        isOn.onNext(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isOn.onNext(false)
        }
        
        
        
    }
    
}
