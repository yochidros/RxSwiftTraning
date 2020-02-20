//
//  TopViewController.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/20.
//  Copyright © 2020 yochidros. All rights reserved.
//

import UIKit


protocol ClassName {
    static var className: String { get }
    var className: String { get }
}

extension ClassName {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassName {}

class TopViewController: UIViewController {

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
    }

}
