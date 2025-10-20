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

// MARK: - 日志发送服务
@objc public class DebugLogger: NSObject {
    @objc public static let shared = DebugLogger()
    private let serverURL = "http://192.168.1.102:3000/log"
    
    private override init() {
        super.init()
    }
    
    @objc public func sendLog(_ message: String, level: String = "info", source: String = "NativeScriptEmbedder") {
        let logData: [String: Any] = [
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "level": level,
            "source": source,
            "message": message,
            "platform": "iOS",
            "device": UIDevice.current.model
        ]
        
        sendLogToServer(logData)
        
        // 同时输出到本地日志
        NSLog("[\(source)] \(message)")
    }
    
    private func sendLogToServer(_ logData: [String: Any]) {
        guard let url = URL(string: serverURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: logData)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("日志发送失败: \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            NSLog("日志序列化失败: \(error.localizedDescription)")
        }
    }
}

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
        
        // 发送初始化日志
        DebugLogger.shared.sendLog("NativeScriptEmbedder 初始化完成", level: "info", source: "NativeScriptEmbedder.init")
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
        DebugLogger.shared.sendLog("开始创建嵌入式视图控制器", level: "info", source: "NativeScriptEmbedder.createEmbeddedViewController")
        NSLog("NativeScriptEmbedder: 创建嵌入式视图控制器")
        let containerVC = NativeScriptContainerViewController()
        containerVC.title = "NativeScript"
        DebugLogger.shared.sendLog("嵌入式视图控制器创建完成", level: "info", source: "NativeScriptEmbedder.createEmbeddedViewController")
        return containerVC
    }
    
    /// 嵌入 NativeScript 视图到指定的容器中
    @objc public func embedNativeScriptView(_ viewController: UIViewController!, in containerVC: NativeScriptContainerViewController) {
        DebugLogger.shared.sendLog("开始嵌入 NativeScript 视图", level: "info", source: "NativeScriptEmbedder.embedNativeScriptView")
        NSLog("NativeScriptEmbedder: 嵌入 NativeScript 视图")
        
        guard let vc = viewController else {
            DebugLogger.shared.sendLog("viewController 为 nil，嵌入失败", level: "error", source: "NativeScriptEmbedder.embedNativeScriptView")
            NSLog("NativeScriptEmbedder: viewController 为 nil")
            return
        }
        
        DebugLogger.shared.sendLog("viewController 有效，开始设置视图", level: "info", source: "NativeScriptEmbedder.embedNativeScriptView")
        
        // 设置背景色
        vc.view.backgroundColor = UIColor.white
        NSLog("NativeScriptEmbedder: 设置 viewController 背景色")
        DebugLogger.shared.sendLog("设置 viewController 背景色完成", level: "info", source: "NativeScriptEmbedder.embedNativeScriptView")
        
        // 嵌入到容器中
        DispatchQueue.main.async {
            DebugLogger.shared.sendLog("在主线程中嵌入视图", level: "info", source: "NativeScriptEmbedder.embedNativeScriptView")
            containerVC.embedNativeScript(vc)
            DebugLogger.shared.sendLog("视图嵌入完成", level: "info", source: "NativeScriptEmbedder.embedNativeScriptView")
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