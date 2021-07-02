SwiftJS是用swift写的，用于演示如何和JavaScript进行交互的Demo.

![演示效果](http://git.oschina.net/uploads/images/2016/0202/100023_12f7b8a1_302364.gif "在这里输入图片标题")

## Features

- [x] JavaScript call Native App
- [x] Native App call JavaScript

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.2+

## Communication

- 如果您需要帮助，请与我联系hengchengfei@sina.com

## Usage

### JavaScript call Native App

```swift
let conf = WKWebViewConfiguration()
let userScript = WKUserScript(source: "redHeader()", injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
conf.userContentController.addUserScript(userScript)
webView = WKWebView(frame: self.view.frame, configuration: conf)
```

### Native App call JavaScript
 1.首先添加一个WKScriptMessageHandler代理
```swift
class ViewController: UIViewController, WKScriptMessageHandler
```

 2.实现«userContentController»的代理方法
```swift
func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message: WKScriptMessage!) {
    if(message.name == "callbackHandler") {
        println("JavaScript is sending a message \(message.body)")
    }
}
```

 3.WebView启动对JavaScript的监听事件
```swift
contentController.addScriptMessageHandler(
    self,
    name: "callbackHandler" 
)
```

 4.H5中，添加如下JavaScript
```swift
webkit.messageHandlers.callbackHandler.postMessage("I Love you");
```