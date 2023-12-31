//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by 백래훈 on 11/3/23.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        setToday()
        
        bind()
        
    }
    
    func setToday() {
        let date = Date()
        
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let year = component.year else { return }
        guard let month = component.month else { return }
        guard let day = component.day else { return }
        
        viewModel.outputYear
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputMonth
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputDay
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    
        viewModel.outputYear
            // MainScheduler.instance는 main thread에서 동작하게 정의해준다.
            .observe(on: MainScheduler.instance) // Schedular
            .subscribe(with: self) { owner, value in
                owner.yearLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.outputMonth
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.outputDay
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

