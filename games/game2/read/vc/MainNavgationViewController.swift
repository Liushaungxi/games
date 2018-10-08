//
//  MainNavgationViewController.swift
//  games
//
//  Created by liushungxi on 2018/9/26.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import WebKit
class MainNavgationViewController: UIViewController,WKNavigationDelegate {
    let webView = WKWebView()
    var mainUrl = ""
    var progressView:UIProgressView = UIProgressView()
    var parsingButton = UIButton(type: UIButtonType.custom)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        webView.navigationDelegate = self
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        progressView.tintColor = UIColor.red
        progressView.isHidden = true
        
        webView.load(URLRequest(url: URL(string: mainUrl)!))
        
        view.addSubview(parsingButton)
        parsingButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalToSuperview()
            make.width.height.equalTo(50)
        }
        parsingButton.setTitle("解析", for: .normal)
        parsingButton.setTitleColor(UIColor.black, for: .normal)
        parsingButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        parsingButton.layer.cornerRadius = 25
        parsingButton.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    @objc func click(){
        let tempUrl = webView.url?.absoluteString
        let vc = CatalogTableViewController()
        vc.currentUrl = tempUrl!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.navigationDelegate = nil
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            let new = change?[.newKey] as? Float ?? 0.0
            let old  = change?[.oldKey] as? Float ?? 0.0
            
            if new<old{
                return
            }
            
            if new == 1{
                progressView.isHidden = true
                progressView.setProgress(0, animated: false)
            }else{
                progressView.isHidden = false
                progressView.setProgress(new, animated: true)
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
