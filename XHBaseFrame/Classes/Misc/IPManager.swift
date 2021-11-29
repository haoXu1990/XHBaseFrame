//
//  IPManager.swift
//  XHBaseFrame_Example
//
//  Created by XuHao on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

public let ipSubject = BehaviorRelay<String?>.init(value: nil)

final public class IPManager {

    var disposeBag = DisposeBag()
    public static let shared = IPManager()

    init() {

    }

    deinit {
    }

    public func start() {
        reachSubject.asObservable()
            .filter { $0 != .unknown && $0 != .notReachable }
            .flatMap { _ in self.request() }
            .subscribe(onNext: { ip in
                ipSubject.accept(ip)
            }).disposed(by: self.disposeBag)
    }

    func request() -> Observable<String> {
        Observable<String>.create { [weak self] observer in
            guard self != nil else { return Disposables.create { } }
            AF.request("https://api.ipify.org", requestModifier: { $0.timeoutInterval = 2 })
                .responseString { response in
                    if let string = response.value, !string.isEmpty {
                        logger.print("本机IP: \(string)", module: .xhframe)
                        observer.onNext(string)
                        observer.onCompleted()
                    } else {
                        let error: Error = response.error ?? XHError.unknown
                        logger.print("本机IP: \(error)", module: .xhframe)
                        observer.onError(error)
                    }
                }
            return Disposables.create { }
        }
    }

}
