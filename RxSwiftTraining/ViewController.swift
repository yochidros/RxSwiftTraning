//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/18.
//  Copyright © 2020 yochidros. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

	@IBOutlet weak var label: UILabel?
	
	private lazy var loadingView: UIActivityIndicatorView? = {
		let p = UIActivityIndicatorView(style: .large)
		p.frame = CGRect(origin: .init(x: 40, y: 50), size: .init(width: 20, height: 20))
		p.color = .red
		p.hidesWhenStopped = true
		self.view.addSubview(p)
		return p
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
