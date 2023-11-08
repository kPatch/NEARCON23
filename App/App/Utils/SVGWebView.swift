//
//  SVGWebView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/24/23.
//

import Foundation
import SwiftUI
import WebKit

struct SVGWebView: UIViewRepresentable {
    let svgString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(svgString, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SVGWebView
        
        init(_ parent: SVGWebView) {
            self.parent = parent
        }
    }
}
