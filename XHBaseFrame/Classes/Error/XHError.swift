//
//  XHError.swift
//  XHBaseFrame_Example
//
//  Created by XuHao on 2021/11/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// 定义错误类型
enum XHError: Error {
    // 网络错误
    case network

    // 需要重新登录
    case needLogin

    // 未知错误
    case unknown
}

/// 实现自定义错误码
extension XHError: CustomNSError {
    static let domain = "com.error"
    var errorCode: Int {
        switch self {
        case .network: return 400
        case .unknown: return -1

        case .needLogin: return 401
        }
    }
}

/// 实现 Localized
extension XHError: LocalizedError {
    /// 概述
    public var failureReason: String? {
        switch self {
        case .unknown: return NSLocalizedString("Error.Unknown.Title", value: "未知错误", comment: "")
        case .network: return NSLocalizedString("Error.Network.Title", value: "网络错误", comment: "不能访问网络")
        case .needLogin: return NSLocalizedString("Error.Network.Title", value: "", comment: "需要重新登录")
        }
    }
    /// 详情
    public var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("Error.Unknown.Message", value: "未知错误", comment: "")
        case .network: return NSLocalizedString("Error.Network.Message", value: "网络错误", comment: "请检查网络情况")
        case .needLogin: return NSLocalizedString("Error.Network.Message", value: "登录错误", comment: "需要重新登录")

        }
    }
    /// 重试
    public var recoverySuggestion: String? {
        switch self {
        case .network: return NSLocalizedString(
            "Error.Network.Suggestion",
            value: NSLocalizedString("Retry", value: "重试", comment: ""),
            comment: ""
        )
        default: return NSLocalizedString("Retry", value: "重试", comment: "")
        }
    }

}
