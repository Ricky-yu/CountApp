//
//  ViewController.swift
//  CountApp
//
//  Created by CHEN SINYU on 2019/12/04.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var countUpButton: UIButton!
    
    @IBOutlet weak var countDownButton: UIButton!
    
    @IBOutlet weak var countResetButton: UIButton!
    
    @IBOutlet weak var countTenButton: UIButton!
    
    @IBOutlet weak var countDownTenButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: CounterRxViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    private func setupViewModel() {
        viewModel = CounterRxViewModel()
        let input = CounterViewModelInput(
            countUpButton: countUpButton.rx.tap.asObservable(),
            countDownButton: countDownButton.rx.tap.asObservable(),
            countResetButton: countResetButton.rx.tap.asObservable(),
            countTenButton: countTenButton.rx.tap.asObservable(),
            countDownTenButton: countDownTenButton.rx.tap.asObservable()
        )
        
        viewModel.setup(input: input)
        
        viewModel.outputs?.counterText.drive(countLabel.rx.text).disposed(by: disposeBag)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.saveCount()
    }

}
