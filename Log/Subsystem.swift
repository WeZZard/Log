//
//  Subsystem.swift
//  Log
//
//  Created on 16/10/2018.
//

import Foundation


/// An identifier string, in reverse DNS notation, representing the
/// subsystem that’s performing logging. For example,
/// `com.your_company.your_subsystem_name`. The subsystem is used for
/// categorization and filtering of related log messages, as well as for
/// grouping related logging settings.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public struct Subsystem: RawRepresentable, ExpressibleByStringLiteral,
    CustomStringConvertible
{
    public typealias RawValue = String
    public var rawValue: RawValue
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.rawValue = value
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.rawValue = value
    }
    
    public var description: String { return rawValue }
    
    /// The main bundle subsystem.
    ///
    public static var `default`: Subsystem {
        return Subsystem(rawValue: Bundle.main.bundleIdentifier ?? "")
    }
}
