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

	private var disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loginButton?.rx
			.tap
			.subscribe(onNext: { [weak self] in
				self?.label?.text = "hello login"
			})
		.disposed(by: disposeBag)
	}
	
}
