//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 백래훈 on 11/2/23.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let phone = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: UIColor.systemOrange)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        phone
            .map { $0.count > 12 }
            .subscribe(with: self) { object, value in
                let color = value ? UIColor.systemBlue : UIColor.systemRed
                object.buttonColor.onNext(color)
                object.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    func setNextButtonEnable(button: UIButton) {
        buttonEnabled
            .bind(to: button.rx.isEnabled)
//            .bind { value in
//                button.isEnabled = value
//            }
            .disposed(by: disposeBag)
    }
    
    func setButtonTextFieldColor(button: UIButton, textField: UITextField) {
        buttonColor
//            .bind(to: button.rx.backgroundColor, textField.rx.tintColor)
            .bind { value in
                button.backgroundColor = value
                textField.tintColor = value
                textField.layer.borderColor = value.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    func setPhoneTextFieldValue(textField: UITextField) {
        phone
            .bind(to: textField.rx.text)
//            .bind { value in
//                textField.text = value
//            }
            .disposed(by: disposeBag)
    }
    
//    func setNextButton() {
//        phone
//            .map { $0.count > 12 }
//            .subscribe(with: self) { object, value in
//                let color = value ? UIColor.systemBlue : UIColor.systemRed
//                object.buttonColor.onNext(color)
//                object.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
//    }
    
    func setPhoneValue(textField: UITextField) {
        textField.rx.text.orEmpty
            .subscribe { value in
                let result = value.formated(by: "###-####-####")
                print(value, result)
                self.phone.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
    
}
