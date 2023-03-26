//
//  WebView.swift
//  Story One
//
//  Created by 윤범태 on 2023/03/25.
//

import SwiftUI
import WebKit
import Combine

/*
 https://stackoverflow.com/questions/66581811/call-evaluatejavascript-from-a-swiftui-button
 */

class WebViewData: ObservableObject {
    /*
     커스텀 JS 데이터 전달
        BodyView의 @StateObject webViewData.functionCaller.send("CUSTOM_JS")
     
     앱이 실행되면
     1) Passthrough: updateUIView(_:context:)
        <- tieFunctionCaller 실행, webView: WKWebView 등록
     2) Passthrough: tieFunctionCaller(data:)
        <- webView?.evaluateJS 실행
     
     @StateObject: @ObservedObject의 발전된 형태로 객체의
        값이 바뀌기 전에 알려주는 퍼블리셔를 의미하며,
        SwiftUI가 화면을 다시 그리는 것을 가능하게 한다는 것은 동일하지만
        @StateObject를 통해서 관찰되고 있는 객체는 그들을 가지고 있는
        화면 구조가 재생성되어도 파괴되지 않는다.
         (=>ObservedObject는 Publisher가 보내주는 신호에 따라 변경되면
         View를 만료시키고 새로 그린다.)
     */
    var functionCaller = PassthroughSubject<String, Never>()
    var shouldUpdateView = true
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var url: URL?
    @StateObject var data: WebViewData
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false  // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true    // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.scrollView.isScrollEnabled = true    // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부
        
        if let url = url {
            webView.load(URLRequest(url: url))    // 지정된 URL 요청 개체에서 참조하는 웹 콘텐츠를로드하고 탐색
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard data.shouldUpdateView else {
            data.shouldUpdateView = false
            return
        }
        print("Passthrough:", #function)
        
        context.coordinator.tieFunctionCaller(data: data)
        context.coordinator.webView = uiView
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(self)
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    /// WebView Representable
    var parentWebView: WebView
    var webView: WKWebView? = nil
    
    private var cancellable: AnyCancellable?
    
    init(_ parentWebView: WebView) {
        self.parentWebView = parentWebView
        super.init()
    }
    
    func tieFunctionCaller(data: WebViewData) {
        print("Passthrough:", #function)
        cancellable = data.functionCaller.sink(receiveValue: { js in
            self.webView?.evaluateJavaScript(js)
        })
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://google.com")
        let webViewData = WebViewData()
        WebView(url: url, data: webViewData)
    }
}
