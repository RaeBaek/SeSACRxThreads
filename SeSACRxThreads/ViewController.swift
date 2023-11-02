//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let async = AsyncSubject<Int>()
    
    let a = PublishSubject<Int>()
    let b = PublishSubject<String>()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
//        asyncSubject()
        combineLatest()
        
    }
    
    func asyncSubject() {
        `async`.onNext(100)
        `async`.onNext(200)
        `async`.onNext(300)
        `async`.onNext(400)
        `async`.onNext(500)
        
        `async`
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposeBag)

        `async`.onCompleted()
        
        `async`.onNext(600)
        `async`.onNext(700)
        `async`.onNext(800)
        
        `async`.onCompleted()
        
        `async`.onNext(900)
        `async`.onNext(1000)
        
    }
    
    func combineLatest() {
        
        let result = Observable.combineLatest(a, b) { first, second in
            return "\(first) 그리고 \(second)"
        }
        
        result
            .subscribe(with: self) { object, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        a.onNext(1)
        a.onNext(2)
        a.onNext(3)
        
        b.onNext("오목교")
        
    }


}

