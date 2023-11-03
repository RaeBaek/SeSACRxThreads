//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 백래훈 on 11/2/23.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let inputPhone = BehaviorSubject(value: "010")
    let outputPhone = PublishSubject<String>()
    let buttonStatus = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        inputPhone
            .map { $0.count > 12 }
            .subscribe(with: self) { object, value in
                object.buttonStatus.onNext(value)
            }
            .disposed(by: disposeBag)
        
        outputPhone
            .map { $0.formated(by: "###-####-####") }
            .subscribe(with: self) { owner, value in
                owner.inputPhone.onNext(value)
            }
            .disposed(by: disposeBag)
 
    }
    
}
