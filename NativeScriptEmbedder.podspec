Pod::Spec.new do |spec|
  spec.name         = "NativeScriptEmbedder"
  spec.version      = "1.0.0"
  spec.summary      = "NativeScript framework embedder for iOS applications"
  spec.description  = <<-DESC
                      A CocoaPods wrapper for the NativeScript framework that allows
                      embedding NativeScript runtime into iOS applications.
                      DESC

  spec.homepage     = "https://github.com/102899/ios-spm-uts"
  spec.license      = { :type => "MIT", :text => <<-LICENSE
                        Copyright OpenJS Foundation and other contributors, https://openjsf.org

                        Permission is hereby granted, free of charge, to any person obtaining a copy
                        of this software and associated documentation files (the "Software"), to deal
                        in the Software without restriction, including without limitation the rights
                        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                        copies of the Software, and to permit persons to whom the Software is
                        furnished to do so, subject to the following conditions:

                        The above copyright notice and this permission notice shall be included in
                        all copies or substantial portions of the Software.

                        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
                        THE SOFTWARE.
                        LICENSE
                      }

  spec.author       = { "NativeScript Team" => "support@nativescript.org" }
  spec.source       = { :git => "https://github.com/102899/ios-spm-uts.git", :branch => "cocoapods-support" }

  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"

  # 使用 vendored_frameworks 来包含 xcframework
  spec.vendored_frameworks = "NativeScript.xcframework"

  # 确保框架被正确链接
  spec.frameworks = "Foundation", "UIKit"
  
  # 如果需要的话，可以添加系统库依赖
  # spec.libraries = "c++", "z"

  # 设置模块映射
  spec.module_name = "NativeScriptEmbedder"
  
  # 确保支持 Swift
  spec.swift_version = "5.0"
  
  # 暴露 NativeScript 框架的头文件
  spec.public_header_files = "NativeScript.xcframework/*/NativeScript.framework/Headers/*.h", "Sources/NativeScriptEmbedder/*.h"
  
  # 由于我们使用的是预编译的 xcframework，不需要源文件
  # 但是为了让 CocoaPods 正确识别，我们可以添加一个空的源文件
  spec.source_files = "Sources/NativeScriptEmbedder/*.{h,m,swift}"
  
  # 设置模块映射文件
  spec.module_map = "Sources/NativeScriptEmbedder/module.modulemap"
  
  # 确保 xcframework 中的所有架构都被支持
  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '',
    'ONLY_ACTIVE_ARCH' => 'NO'
  }
end