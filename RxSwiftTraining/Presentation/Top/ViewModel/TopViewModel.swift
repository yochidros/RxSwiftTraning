//
//  TopViewModel.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/20.
//  Copyright © 2020 yochidros. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TopViewModelInput {
	let countUpButton: Observable<Void>?
	let countDownButton: Observable<Void>?
	let resetButton: Observable<Void>?
}

protocol TopViewModelOutput {
	var counterText: Driver<String?> { get }
}

protocol TopViewModelType {
	var outputs: TopViewModelOutput? { get }
	func setup(input: TopViewModelInput)
}

class TopViewModel: TopViewModelType {
	var outputs: TopViewModelOutput?
	private let countRelay = BehaviorRelay<Int>(value: 0)
	private let count: Int = 0
	private let disposeBag = DisposeBag()
	
	init() {
		self.outputs = self
		resetCount()
	}
	
	func setup(input: TopViewModelInput) {
		input.countUpButton?
			.subscribe(onNext: { [weak self] in
				self?.incrementCount()
			})
			.disposed(by: disposeBag)
		
		input.countDownButton?
			.subscribe(onNext: { [weak self] in
				self?.decrementCount()
			})
			.disposed(by: disposeBag)
		input.resetButton?
			.subscribe(onNext: { [weak self] in
				self?.resetCount()
			})
			.disposed(by: disposeBag)
	}
	
	private func incrementCount() {
		countRelay.accept(countRelay.value+1)
	}
	
	private func decrementCount() {
		countRelay.accept(countRelay.value-1)
	}
	
	private func resetCount() {
		countRelay.accept(0)
	}
}

extension TopViewModel: TopViewModelOutput {
	var counterText: Driver<String?> {
		return countRelay
			.map { "Rx: \($0)" }
			.asDriver(onErrorDriveWith: Driver.empty())
	}
}
