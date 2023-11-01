//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
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
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 25)
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
        
        birthDayPicker.rx.date
            .bind(to: birthday)
            .disposed(by: disposeBag)
        
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        birthday
            .subscribe(with: self) { object, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                object.year.onNext(component.year!)
                object.month.onNext(component.month!)
                object.day.onNext(component.day!)
                
            } onDisposed: { object in
                print("birthday disposed")
            }
//            .dispose() // 즉시 resource 정리
            .disposed(by: disposeBag)
        
        birthday
            .subscribe(with: self) { object, date in
                let today = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                if let tYear = today.year, let tMonth = today.month, let tDay = today.day,
                   let cYear = component.year, let cMonth = component.month, let cday = component.day {
                    let year = tYear - cYear
                    let month = tMonth - cMonth
                    let day = tDay - cday
                    
                    // 태어난지 17년째 되는 년 + 오늘의 월이 내 생일의 월보다 같거나 커야함
                    if year >= 17 && month >= 0 {
                        // 오늘의 월은 같은데 오늘의 일이 내 생일보다 작다면 아직 내 생일은 오지 않음
                        if month == 0 && day < 0 {
                            object.buttonEnabled.onNext(false)
                        } else {
                            object.buttonEnabled.onNext(true)
                        }
                    } else {
                        object.buttonEnabled.onNext(false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        year
            .observe(on: MainScheduler.instance)
            .map { "\($0)년" }
            .subscribe(with: self) { object, value in
                object.yearLabel.text = value
            } onDisposed: { object in
                print("year dispose")
            }
            .disposed(by: disposeBag)
        
        month
            .subscribe(with: self) { object, value in
                object.monthLabel.text = "\(value)월"
            } onDisposed: { object in
                print("month dispose")
            }
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        do {
            let birthday = try birthday.value()
            print(birthday, "가입완료")
        } catch {
            print("생일을 불러오지 못했습니다.")
        }
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
