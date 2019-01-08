//
//  DetailsViewController.swift
//  fptech
//
//  Created by Pankaj Verma on 08/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import UIKit
import WebKit
class DetailsViewController: UIViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!

    @IBOutlet weak var webView: WKWebView!
    var urlString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        if let urlStr = urlString {
            if let url = URL(string: urlStr){
              
                self.webView.addSubview(self.activity)
                self.activity.hidesWhenStopped = true
                self.activity.startAnimating()
                self.webView.navigationDelegate = self
                webView.load(URLRequest(url: url))

            }
        }
    }
}


extension DetailsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activity.stopAnimating()
    }
}
