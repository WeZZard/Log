//
//  Category.swift
//  Log
//
//  Created on 16/10/2018.
//


/// A category within the specified subsystem. The category is used for
/// categorization and filtering of related log messages, as well as for
/// grouping related logging settings within the subsystem’s settings. A
/// category’s logging settings override those of the parent subsystem.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public struct Category: RawRepresentable, ExpressibleByStringLiteral,
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
}
