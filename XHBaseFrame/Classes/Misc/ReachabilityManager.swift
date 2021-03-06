//
//  ReachabilityManager.swift
//  XHBaseFrame_Example
//
//  Created by XuHao on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

public let reachSubject = BehaviorRelay<NetworkReachabilityManager.NetworkReachabilityStatus>.init(value: .unknown)

final public class ReachabilityManager {

    public static let shared = ReachabilityManager()

    let network = NetworkReachabilityManager.init()

    init() {

    }

    deinit {
    }

    func start() {
        self.network?.startListening(onUpdatePerforming: { status in
            logger.print("网络状态: \(status)", module: .xhframe)
            reachSubject.accept(status)
        })
    }

}

extension NetworkReachabilityManager.NetworkReachabilityStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "未知网络"
        case .notReachable: return "网络不可达"
        case let .reachable(type): return type == .cellular ? "cellular" : "wifi"
        }
    }
}

