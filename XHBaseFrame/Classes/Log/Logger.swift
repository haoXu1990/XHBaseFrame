//
//  Logger.swift
//  XHBaseFrame_Example
//
//  Created by XuHao on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyBeaver

public let sblog = SwiftyBeaver.self
public let logger = Logger.init()

public protocol LoggerCompatible {

    func print(
        _ message: @autoclosure () -> Any,
        module: Logger.Module,
        level: SwiftyBeaver.Level,
        file: String,
        function: String,
        line: Int,
        context: Any?
    )

}

public struct Logger {

    public typealias Module = String

    public init() {
    }

    public func print(
        _ message: @autoclosure () -> Any,
        module: Module = .debug,
        level: SwiftyBeaver.Level = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        context: Any? = nil
    ) {
        if let compatible = self as? LoggerCompatible {
            compatible.print(
                message(),
                module: module,
                level: level,
                file: file,
                function: function,
                line: line,
                context: context
            )
        } else {
            sblog.custom(
                level: level,
                message: "【\(module)】\(message())",
                file: file,
                function: function,
                line: line,
                context: context
            )
        }
    }

}

extension Logger.Module {
    /// 普通 Debug
    public static var debug: Logger.Module { "debug" }
    /// XHFrame 中的错误
    public static var xhframe: Logger.Module { "xhframe" }

    public static var library: Logger.Module { "library" }
    
    public static var restful: Logger.Module { "restful" }
}

