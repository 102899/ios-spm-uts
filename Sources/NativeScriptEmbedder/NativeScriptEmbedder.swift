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
    @objc optional func embedNativeScriptView(_ viewController: UIViewController!) -> UIViewController!
}

// MARK: - NativeScript 容器视图控制器
@objc public class NativeScriptContainerViewController: UIViewController {
    private var nativeScriptViewController: UIViewController?
    private var containerView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    private func setupContainerView() {
        // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // 设置约束，使容器视图填满整个视图
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLog("NativeScriptContainer: 容器视图设置完成")
    }
    
    @objc public func embedNativeScript(_ viewController: UIViewController) {
        NSLog("NativeScriptContainer: 开始嵌入 NativeScript 视图控制器")
        
        // 移除之前的子视图控制器（如果有）
        if let previousVC = nativeScriptViewController {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
        
        // 添加新的子视图控制器
        nativeScriptViewController = viewController
        addChild(viewController)
        
        // 设置视图约束
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        viewController.didMove(toParent: self)
        NSLog("NativeScriptContainer: NativeScript 视图控制器嵌入完成")
    }
    
    @objc public func removeNativeScript() {
        guard let vc = nativeScriptViewController else { return }
        
        NSLog("NativeScriptContainer: 移除 NativeScript 视图控制器")
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        nativeScriptViewController = nil
    }
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
    /// JavaScript 代码通过 NativeScriptEmbedder.sharedInstance() 访问
    @objc public static func sharedInstance() -> NativeScriptEmbedder {
        return shared
    }
    
    /// Objective-C 兼容的 delegate 设置方法
    /// 使用不同的方法名避免与属性的 setter 冲突
    /// Swift 代码可以调用此方法：NativeScriptEmbedder.sharedInstance().assignDelegate(delegate)
    @objc public func assignDelegate(_ delegate: NativeScriptEmbedderDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - 嵌入式视图方法
    
    /// 创建嵌入式 NativeScript 容器视图控制器
    @objc public func createEmbeddedViewController() -> NativeScriptContainerViewController {
        NSLog("NativeScriptEmbedder: 创建嵌入式视图控制器")
        let containerVC = NativeScriptContainerViewController()
        containerVC.title = "NativeScript"
        return containerVC
    }
    
    /// 嵌入 NativeScript 视图到指定的容器中
    @objc public func embedNativeScriptView(_ viewController: UIViewController!, in containerVC: NativeScriptContainerViewController) {
        NSLog("NativeScriptEmbedder: 嵌入 NativeScript 视图")
        
        guard let vc = viewController else {
            NSLog("NativeScriptEmbedder: viewController 为 nil")
            return
        }
        
        // 设置背景色
        vc.view.backgroundColor = UIColor.white
        NSLog("NativeScriptEmbedder: 设置 viewController 背景色")
        
        // 嵌入到容器中
        DispatchQueue.main.async {
            containerVC.embedNativeScript(vc)
        }
    }
    
    // MARK: - NativeScriptEmbedderDelegate
    
    /// 默认的模态显示方法（保持向后兼容）
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
    
    /// 新的嵌入式视图方法
    @objc public func embedNativeScriptView(_ viewController: UIViewController!) -> UIViewController! {
        NSLog("NativeScriptEmbedder: embedNativeScriptView 被调用")
        
        guard let vc = viewController else {
            NSLog("NativeScriptEmbedder: viewController 为 nil")
            return nil
        }
        
        // 创建容器视图控制器
        let containerVC = createEmbeddedViewController()
        
        // 嵌入 NativeScript 视图
        embedNativeScriptView(vc, in: containerVC)
        
        return containerVC
    }
}