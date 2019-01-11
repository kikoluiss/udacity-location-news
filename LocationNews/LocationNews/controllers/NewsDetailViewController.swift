//
//  NewsDetailViewController.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var url: String!
    
    var spinnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: self.url) {
            self.spinnerView = UIViewController.displaySpinner(onView: self.view)
            let request = URLRequest(url: url)
            self.webView.navigationDelegate = self
            self.webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIViewController.removeSpinner(spinner: self.spinnerView)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIViewController.removeSpinner(spinner: self.spinnerView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
