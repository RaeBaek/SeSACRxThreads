//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let word = PublishSubject<String>() //BehaviorSubject(value: "")
    let buttonHidden = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
        nextButton.isHidden = true
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
        
    }
    
    func bind() {
        buttonHidden
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        word
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        word
            //.distinctUntilChanged()
            .map { $0.count >= 2 && $0.count < 6 }
            .subscribe(with: self) { object, value in
                print(value)
                object.buttonHidden.onNext(!value)
            }
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .subscribe(with: self) { object, value in
                object.word.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
