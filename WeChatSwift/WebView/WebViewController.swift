//
//  WebViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let url: URL
    
    private var webView: WCWebView!
    private var progressBar: UIProgressView!
    private var addressLabel: UILabel!
    private var estimatedProgressObserver: NSObject?
    
    init(url: URL, presentModal: Bool = false, extraInfo: [String: Any] = [:]) {
        if url.scheme == nil {
            self.url = URL(string: "http://" + url.absoluteString)!
        } else {
            self.url = url
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WebViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        setupAddressLabel()
        setupWebView()
        setupProgressBar()
        observeProgress()
    
        let request = URLRequest(url: url)
        webView.load(request)
        
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        
        webView = WCWebView(frame: view.bounds, configuration: configuration)
        webView.delegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        webView.scrollView.backgroundColor = .clear
    }
    
    private func setupAddressLabel() {
        addressLabel = UILabel()
        addressLabel.frame = CGRect(x: 10, y: 6, width: view.bounds.width - 20, height: 15)
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textColor = UIColor(white: 0, alpha: 0.3)
        addressLabel.textAlignment = .center
        view.addSubview(addressLabel)
    }

    private func setupProgressBar() {
        let frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 3)
        progressBar = UIProgressView(frame: frame)
        progressBar.backgroundColor = UIColor(hexString: "#00BF12")
        progressBar.progressTintColor = UIColor(hexString: "#00BF12")
        progressBar.progress = 0.6
        view.addSubview(progressBar)
    }
    
    private func observeProgress() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] (webView, _) in
            self?.progressBar.progress = Float(webView.estimatedProgress)
            self?.progressBar.isHidden = webView.estimatedProgress == 1.0
        }
    }
}

// MARK: - Event Handlers
extension WebViewController {
    
    @objc private func moreButtonClicked() {
        
    }
    
}

// MARK: - WCWebViewDelegate
extension WebViewController: WCWebViewDelegate {
    
    var allowInlineMediaPlay: Bool { return true }
    
    func webView(_ webView: WCWebView, didFinishLoad navigation: WKNavigation) {
        navigationItem.title = webView.title
        if let host = webView.url?.host {
            addressLabel.text = "此网页由 \(host) 提供"
        }
    }
}
