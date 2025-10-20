//
//  NativeScriptEmbedder.swift
//  NativeScriptEmbedder
//
//  Created by CocoaPods integration
//  Copyright © 2024 NativeScript Team. All rights reserved.
//

import Foundation
import UIKit

// This file is required by CocoaPods to recognize the module
// The actual NativeScript functionality is provided by the NativeScript.xcframework

@objc public protocol NativeScriptEmbedderDelegate: NSObjectProtocol {
    @objc func presentNativeScriptApp(_ viewController: UIViewController!) -> Any!
}

@objc public class NativeScriptEmbedder: NSObject, NativeScriptEmbedderDelegate {
    
    @objc public static let shared = NativeScriptEmbedder()
    @objc public weak var delegate: NativeScriptEmbedderDelegate?
    
    private override init() {
        super.init()
        // 设置自己为默认 delegate
        self.delegate = self
    }
    
    @objc public var version: String {
        return "1.0.0"
    }
    
    // MARK: - Objective-C 兼容方法
    
    /// Objective-C 兼容的单例访问方法
    @objc public static func sharedInstance() -> NativeScriptEmbedder {
        return shared
    }
    
    /// Objective-C 兼容的 delegate 设置方法
    @objc public func setDelegate(_ delegate: NativeScriptEmbedderDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - NativeScriptEmbedderDelegate
    @objc public func presentNativeScriptApp(_ viewController: UIViewController!) -> Any! {
        NSLog("NativeScriptEmbedder: presentNativeScriptApp 被调用")
        
        guard let vc = viewController else {
            NSLog("NativeScriptEmbedder: viewController 为 nil")
            return nil
        }
        
        // 设置背景色
        vc.view.backgroundColor = UIColor.white
        NSLog("NativeScriptEmbedder: 设置 viewController 背景色")
        
        // 获取当前的根视图控制器
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                
                NSLog("NativeScriptEmbedder: 准备显示 NativeScript 应用")
                
                // 以模态方式显示 NativeScript 应用
                rootViewController.present(vc, animated: true) {
                    NSLog("NativeScriptEmbedder: NativeScript 应用显示完成")
                }
            } else {
                NSLog("NativeScriptEmbedder: 无法获取根视图控制器")
            }
        }
        
        return vc
    }
}