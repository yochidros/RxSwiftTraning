//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/18.
//  Copyright © 2020 yochidros. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class ViewController: UIViewController {

	@IBOutlet weak var label: UILabel?
	@IBOutlet weak var loginButton: UIButton?
	@IBOutlet weak var textField: UITextField?

	private var disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loginButton?.rx
			.tap
			.subscribe(onNext: { [weak self] in
				self?.label?.text = "hello login"
			})
		.disposed(by: disposeBag)
		guard let l = label else { return }
		textField?.rx.text
			.map({ (text) -> String? in
				guard let t = text else { return nil }
				return t
			})
			.filterNil()
			.bind(to: l.rx.text)
			.disposed(by: disposeBag)
		
		_ = muJust(100)
			.subscribe(onNext: { (value) in
				print(value)
			})
	}
	
	private func muJust<E>(_ element: E) -> Observable<E> {
		return Observable.create { observer -> Disposable in
			observer.on(.next(element))
			observer.on(.completed)
			return Disposables.create()
		}
	}
}
