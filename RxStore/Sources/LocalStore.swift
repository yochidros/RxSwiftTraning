//
//  LocalStore.swift
//  RxStore
//
//  Created by yochidros on 2020/02/21.
//  Copyright © 2020 yochidros. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

class CounterRealmData: Object {
	@objc dynamic var id: Int = 1
	@objc dynamic var count: Int = 0
	@objc dynamic var timestamp: Date = Date()
	
	static override func primaryKey() -> String? {
		return "id"
	}
}

public enum LocalStoreError: Error {
	case initialize
	case realm(Error)
	case writeEmpty
	
	var localizedDescription: String {
		switch self {
		case .initialize:
			return "Local Store can't Not Initialize"
		case .realm(let e):
			return "Local Store realm: \(e.localizedDescription)"
		case .writeEmpty:
			return "Local Store can't write due to object is Empty"
		}
	}
}

public protocol LocalStoreDataTranslater {
	associatedtype Input
	associatedtype Output
	static func translate(input: Input) -> Output
	static func reverseTranslate(input: Output) -> Input
}

public struct CounterData {
	public let count: Int
	public let timestamp: Date
	public init(count: Int, timestamp: Date = Date()) {
		self.count = count
		self.timestamp = timestamp
	}
}

class CounterTranslater: LocalStoreDataTranslater {
	typealias Input = CounterData
	typealias Output = CounterRealmData
	
	static func translate(input: CounterData) -> CounterRealmData {
		let data = CounterRealmData(value: input)
		return data
	}
	static func reverseTranslate(input: CounterRealmData) -> CounterData {
		let data = CounterData.init(count: input.count, timestamp: input.timestamp)
		return data
	}
}

public protocol LocalStoreAccessor {
	associatedtype Translater: LocalStoreDataTranslater
	var localStore: LocalStore? { get }
	func read() -> Result<[Translater.Input], LocalStoreError>
	func write(input: [Translater.Input])
}

public protocol CounterLocalStorage {
	func readData() -> [CounterData]
	func writeData(input: [CounterData]) -> Bool
}

public class CounterLocalStorageFactory {
	public static func create() -> CounterLocalStorage {
		return CounterLocalStoreAccessor()
	}
}
class CounterLocalStoreAccessor: CounterLocalStorage, LocalStoreAccessor {
	var localStore: LocalStore? {
		return LocalStore()
	}
	
	func readData() -> [CounterData] {
		switch read() {
		case .success(let d):
			return d
		case .failure(let e):
			dump(e)
			return []
		}
	}
	
	func writeData(input: [CounterData]) -> Bool {
		write(input: input)
		return true
	}
	
	typealias Translater = CounterTranslater
	
	internal func read() -> Result<[CounterData], LocalStoreError> {
		let result = localStore?.read(type: Translater.Output.self)
		switch result {
		case .success(let data):
			return .success(data.map({ CounterData.init(count: $0.count, timestamp: $0.timestamp)}))
		case .failure(let e):
			return .failure(e)
		case .none:
			return .failure(.initialize)
		}
	}
	
	internal func write(input: [CounterData]) {
		let data = input.map { (d) -> CounterRealmData in
			let da = CounterRealmData()
			da.count = d.count
			da.timestamp = d.timestamp
			return da
		}
		localStore?.write(input: data)
	}
}
public class LocalStore: NSObject {
	private var realm: Realm!
	private let disposeBag = DisposeBag()
	
	var realmConfig = Realm.Configuration.defaultConfiguration
	
	public override init() {
		super.init()
		realmConfig.schemaVersion = 1
		realmConfig.migrationBlock = { migrantion, old in
			if old < 1 {
				migrantion.enumerateObjects(ofType: CounterRealmData.className()) { (old, new) in
					if let count = old?["count"] as? Int, count == 0 {
						new?["id"] = 1
					} else {
						guard let o = old else { return }
						migrantion.delete(o)
					}
				}
			}
				
		}
		self.setup()
	}
	
	private func setup() {
		do {
			realm = try Realm.init(configuration: realmConfig)
		} catch let e {
			dump(e)
		}
	}
	
	func read<T: Object>(type: T.Type) -> Result<[T], LocalStoreError> {
		guard let r = self.realm else {
			return .failure(.initialize)
		}
		let obj = r.objects(T.self)
		
//		Observable.collection(from: obj)
//			.map { $0 }
//			.subscribe(onNext: { o in
//				print(o)
//			})

		return .success(obj.map({ $0 }))
	}
	
	@discardableResult
	func write<T: Object>(input: [T]) -> LocalStoreError? {
		guard let r = self.realm else {
			return .initialize
		}
		guard !input.isEmpty else {
			return .writeEmpty
		}
		
		Observable.from(optional: input)
			.subscribe(r.rx.add(update: .all, onError: { (el, error) in
				if let elements = el {
					print("ERROR: \(elements)")
				} else {
					print("ERROR: \(error.localizedDescription)")
				}
			}))
			.disposed(by: disposeBag)
		return nil
	}

}
