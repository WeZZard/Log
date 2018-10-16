//
//  OSLog+Log.swift
//  Log
//
//  Created on 16/10/2018.
//


@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
extension OSLog {
    public convenience init(
        subsystem: Subsystem,
        category: Log.Category
        )
    {
        self.init(
            subsystem: subsystem.rawValue,
            category: category.rawValue
        )
    }
    
    public static func make(presetBehavior: LogPresetBehavior) -> OSLog {
        switch presetBehavior {
        case .`default`:    return .`default`
        case .disabled:     return .disabled
        }
    }
}
