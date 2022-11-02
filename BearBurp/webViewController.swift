//
//  webViewController.swift
//  JiarongLiang-Lab4
//
//  Created by 梁家榕 on 10/31/22.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url:URLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // web view
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        webView.load(url)
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
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
