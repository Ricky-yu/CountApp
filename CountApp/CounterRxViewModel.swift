//
//  CounterRxViewModel.swift
//  CountApp
//
//  Created by CHEN SINYU on 2019/12/05.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct CounterViewModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
    let countTenButton: Observable<Void>
    let countDownTenButton: Observable<Void>
}

protocol CounterViewModelOutput {
    var counterText: Driver<String?> {get}
}

protocol CounterViewModelType {
    var outputs: CounterViewModelOutput? {get}
    func setup(input: CounterViewModelInput)
}


class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewModelOutput?
    
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
        let count = UserDefaults.standard.integer(forKey: "Count")
        countRelay.accept(count)
    }
    
    func setup(input: CounterViewModelInput) {
        
        
        input.countUpButton
            .subscribe(onNext: {[weak self] in
                self?.incrementCount()
            }).disposed(by: disposeBag)
        
        input.countDownButton.subscribe(onNext: {[weak self] in
            self?.decrementCount()
        }).disposed(by:disposeBag)
        
        input.countResetButton.subscribe(onNext: {[weak self] in
            self?.resetCount()
        }).disposed(by:disposeBag)
        
        input.countTenButton.subscribe(onNext: {[weak self] in
            self?.incrementTenCount()
        }).disposed(by: disposeBag)
        
        input.countDownTenButton.subscribe(onNext: {[weak self] in
            self?.decrementTenCount()
        }).disposed(by: disposeBag)
    }
    
    func saveCount() {
        UserDefaults.standard.set(countRelay.value,forKey: "Count")
    }
    
    private func incrementCount() {
        let count = countRelay.value + 1
        countRelay.accept(count)
    }
    
    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count)
    }
    
    private func resetCount() {
        countRelay.accept(initialCount)
    }
    
    private func incrementTenCount() {
        let count = countRelay.value + 10
        countRelay.accept(count)
    }
    private func decrementTenCount() {
        let count = countRelay.value - 10
        countRelay.accept(count)
    }
    
}

extension CounterRxViewModel: CounterViewModelOutput {
    var counterText: Driver<String?> {
        return countRelay.map{"RxPartten:\($0)"}.asDriver(onErrorJustReturn:nil)
    }
}
