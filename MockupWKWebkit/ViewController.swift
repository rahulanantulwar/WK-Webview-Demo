//
//  ViewController.swift
//  MockupWKWebkit
//
//  Created by Rahul Anantulwar on 9/26/18.
//  Copyright © 2018 Rahul Anantulwar. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    // Creating web view
    @IBOutlet weak var spinne: UIActivityIndicatorView!
    var webView: WKWebView!

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinne.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinne.stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        let myURL = URL(string:"https://aao-cali-s3.s3.amazonaws.com/AAO.production/inputs/e6b2a04b-0c62-4eda-b8b5-52d3a64f590c/PEDIG.mp4")
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
        self.view.addSubview(self.webView)
        webView.load(myRequest)
        
         self.webView.addSubview(self.spinne)
         self.spinne.startAnimating()
         //self.webView.navigationDelegate = self
         self.spinne.hidesWhenStopped = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}


