//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 백래훈 on 11/3/23.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let inputYear = PublishSubject<Int>()
    let outputYear = PublishSubject<String>()
    
    let inputMonth = PublishSubject<Int>()
    let outputMonth = PublishSubject<String>()
    
    let inputDay = PublishSubject<Int>()
    let outputDay = PublishSubject<String>()
    
    let buttonStatus = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .subscribe(with: self) { object, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                guard let year = component.year else { return }
                guard let month = component.month else { return }
                guard let day = component.day else { return }
                
                object.inputYear.onNext(year)
                object.inputMonth.onNext(month)
                object.inputDay.onNext(day)
                
            }
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
                            object.buttonStatus.onNext(false)
                        } else {
                            object.buttonStatus.onNext(true)
                        }
                    } else {
                        object.buttonStatus.onNext(false)
                    }
                }
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
