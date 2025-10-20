//
//  NativeScriptEmbedder.swift
//  NativeScriptEmbedder
//
//  Created by CocoaPods integration
//  Copyright © 2024 NativeScript Team. All rights reserved.
//

import Foundation

// This file is required by CocoaPods to recognize the module
// The actual NativeScript functionality is provided by the NativeScript.xcframework

@objc public class NativeScriptEmbedder: NSObject {
    
    @objc public static let shared = NativeScriptEmbedder()
    
    private override init() {
        super.init()
    }
    
    @objc public var version: String {
        return "1.0.0"
    }
}