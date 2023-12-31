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
    
    let viewModel = PhoneViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        //buttonColor는 true or false
        viewModel.buttonStatus
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.systemBlue : UIColor.systemRed
                
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
                
                owner.phoneTextField.tintColor = color
                owner.phoneTextField.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)
        
        viewModel.inputPhone
            .subscribe(with: self) { owner, value in
                owner.phoneTextField.text = value
            }
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.outputPhone.onNext(value)
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
