//
//  Type.swift
//  Log
//
//  Created on 16/10/2018.
//


/// A log type controls the conditions under which a message should be
/// logged.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public struct Type: RawRepresentable {
    public typealias RawValue = OSLogType
    public var rawValue: RawValue
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    
    public static let `default` = Type(rawValue: .`default`)
    public static let info = Type(rawValue: .info)
    public static let debug = Type(rawValue: .debug)
    public static let error = Type(rawValue: .error)
    public static let fault = Type(rawValue: .fault)
}
