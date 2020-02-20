//
//  TopViewController.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/20.
//  Copyright © 2020 yochidros. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TopViewController: UIViewController {

	@IBOutlet weak var label: UILabel?
	@IBOutlet weak var countUpButton: UIButton?
	@IBOutlet weak var countDownButton: UIButton?
	@IBOutlet weak var resetButton: UIButton?
	
	private var viewModel: TopViewModel!
	private let disposeBag = DisposeBag()
	
	init() {
		super.init(nibName: TopViewController.className, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		setup()
    }
	
	private func setup() {
		viewModel = TopViewModel()
		let input = TopViewModelInput(
			countUpButton: countUpButton?.rx.tap.asObservable(),
			countDownButton: countDownButton?.rx.tap.asObservable(),
			resetButton: resetButton?.rx.tap.asObservable()
		)
		viewModel.setup(input: input)
		guard let l = self.label else { return }
		viewModel.outputs?
			.counterText
			.drive(l.rx.text)
			.disposed(by: disposeBag)
	}

}
