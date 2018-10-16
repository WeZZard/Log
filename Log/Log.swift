//
//  Log.swift
//  Log
//
//  Created on 24/2/2018.
//

import Foundation
import os.log


/// Log with subsystem, category and type.
///
/// - Parameter subsystem:  The subsystem generates this log. The default
/// value is `default`, which means the main bundle.
///
/// - Parameter category: The category of this log.
///
/// - Parameter type: Log type. The dafault value is `default`.
///
/// - Parameter dso: The dynamic shared object handle invokes this log.
///   The framework fills this blanket on behalf of you.
///
/// - Parameter message: The formatted message.
///
/// - Parameter args: The arguments to be filled in the formatted message.
///
// MARK: - Log with Subsystem & Category
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public func log(
    subsystem: Subsystem = .`default`,
    category: Category,
    type: Type = .`default`,
    dso: UnsafeRawPointer? = #dsohandle,
    message: StaticString,
    _ args: CVarArg...
    )
{
    let log = OSLog(subsystem: subsystem, category: category)
    let rawType = type.rawValue
    guard log.isEnabled(type: rawType) else { return }
    let returnAddress = __LGReturnAddress()
    
    message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
        // Since dladdr is in libc, it is safe to unsafeBitCast
        // the cstring argument type.
        buf.baseAddress!.withMemoryRebound(
            to: CChar.self, capacity: buf.count
        ) { format in
            withVaList(args) { argList in
                __LGLogvImpl(dso, returnAddress, log, rawType, format, argList)
            }
        }
    }
}


/// Log with subsystem, class and type.
///
/// - Parameter subsystem:  The subsystem generates this log. The default
/// value is `default`, which means the main bundle.
///
/// - Parameter class: The class generates this log.
///
/// - Parameter type: Log type. The dafault value is `default`.
///
/// - Parameter dso: The dynamic shared object handle invokes this log.
///   The framework fills this blanket on behalf of you.
///
/// - Parameter message: The formatted message.
///
/// - Parameter args: The arguments to be filled in the formatted message.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public func log(
    subsystem: Subsystem = .`default`,
    class: AnyClass,
    type: Type = .`default`,
    dso: UnsafeRawPointer? = #dsohandle,
    message: StaticString,
    _ args: CVarArg...
    )
{
    let category = Category(rawValue: "\(`class`)")
    let log = OSLog(subsystem: subsystem, category: category)
    let rawType = type.rawValue
    guard log.isEnabled(type: rawType) else { return }
    let returnAddress = __LGReturnAddress()
    
    message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
        // Since dladdr is in libc, it is safe to unsafeBitCast
        // the cstring argument type.
        buf.baseAddress!.withMemoryRebound(
            to: CChar.self, capacity: buf.count
        ) { format in
            withVaList(args) { argList in
                __LGLogvImpl(dso, returnAddress, log, rawType, format, argList)
            }
        }
    }
}


/// Log with subsystem, object and type.
///
/// - Parameter subsystem:  The subsystem generates this log. The default
/// value is `default`, which means the main bundle.
///
/// - Parameter object: The object generates this log.
///
/// - Parameter type: Log type. The dafault value is `default`.
///
/// - Parameter dso: The dynamic shared object handle invokes this log.
///   The framework fills this blanket on behalf of you.
///
/// - Parameter message: The formatted message.
///
/// - Parameter args: The arguments to be filled in the formatted message.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public func log(
    subsystem: Subsystem = .`default`,
    object: AnyObject,
    type: Type = .`default`,
    dso: UnsafeRawPointer? = #dsohandle,
    message: StaticString,
    _ args: CVarArg...
    )
{
    let category = Category(rawValue: "\(Swift.type(of: object))")
    let log = OSLog(subsystem: subsystem, category: category)
    let rawType = type.rawValue
    guard log.isEnabled(type: rawType) else { return }
    let returnAddress = __LGReturnAddress()
    
    message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
        // Since dladdr is in libc, it is safe to unsafeBitCast
        // the cstring argument type.
        buf.baseAddress!.withMemoryRebound(
            to: CChar.self, capacity: buf.count
        ) { format in
            withVaList(args) { argList in
                __LGLogvImpl(dso, returnAddress, log, rawType, format, argList)
            }
        }
    }
}


/// Log with preset behavior.
///
/// - Parameter presetBehavior:  The preset behavior. The default value is
///  `default`.
///
/// - Parameter type: Log type. The dafault value is `default`.
///
/// - Parameter dso: The dynamic shared object handle invokes this log.
///   The framework fills this blanket on behalf of you.
///
/// - Parameter message: The formatted message.
///
/// - Parameter args: The arguments to be filled in the formatted message.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public func log(
    presetBehavior: LogPresetBehavior = .`default`,
    type: Type = .`default`,
    dso: UnsafeRawPointer? = #dsohandle,
    message: StaticString,
    _ args: CVarArg...
    )
{
    let log = OSLog.make(presetBehavior: presetBehavior)
    let rawType = type.rawValue
    guard log.isEnabled(type: rawType) else { return }
    let returnAddress = __LGReturnAddress()
    
    message.withUTF8Buffer { (buf: UnsafeBufferPointer<UInt8>) in
        // Since dladdr is in libc, it is safe to unsafeBitCast
        // the cstring argument type.
        buf.baseAddress!.withMemoryRebound(
            to: CChar.self, capacity: buf.count
        ) { format in
            withVaList(args) { argList in
                __LGLogvImpl(dso, returnAddress, log, rawType, format, argList)
            }
        }
    }
}
