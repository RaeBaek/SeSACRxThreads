//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요.")
    let nextButton = PointButton(title: "다음")
    
    let phone = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: UIColor.systemOrange)
    let buttonEnabled = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        buttonColor
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        buttonColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        phone
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
//        phone
//            .map { $0.count > 12 }
//            .subscribe { value in
//                print(value)
//                let color = value ? UIColor.systemBlue : UIColor.systemOrange
//                self.buttonColor.onNext(color)
//                self.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
        
//        phone
//            .map { $0.count > 12 }
//            .withUnretained(self) // RxSwift 6
//            .subscribe { object, value in
//                print(value)
//                let color = value ? UIColor.systemBlue : UIColor.systemOrange
//                object.buttonColor.onNext(color)
//                object.buttonEnabled.onNext(value)
//            }
//            .disposed(by: disposeBag)
        
        phone
            .map { $0.count > 12 }
            .subscribe(with: self) { object, value in // RxSwift 6.1
                print(value)
                let color = value ? UIColor.systemBlue : UIColor.systemOrange
                object.buttonColor.onNext(color)
                object.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .subscribe { value in
                let result = value.formated(by: "###-####-####")
                print(value, result)
                self.phone.onNext(result)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
