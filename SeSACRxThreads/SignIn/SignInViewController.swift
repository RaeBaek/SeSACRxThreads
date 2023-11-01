//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    let test = UISwitch()
    
    let isOn = PublishSubject<Bool>() //BehaviorSubject(value: true) //Observable.of(true)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        switchTest()
    }
    
    func switchTest() {
        view.addSubview(test)
        test.snp.makeConstraints {
            $0.top.equalTo(150)
            $0.leading.equalTo(100)
        }
        
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
        
        isOn
            .bind { value in
                self.test.setOn(value, animated: true)
                print("양방향 동작?")
            }
            .disposed(by: disposeBag)
        
        isOn.onNext(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isOn.onNext(false)
        }
        
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
