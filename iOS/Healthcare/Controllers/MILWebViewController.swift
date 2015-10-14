/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation
import UIKit

@objc
protocol MILWebViewDelegate {
    optional func webViewHasChanged(pathComponents: Array<String>)
    optional func nativeViewHasChanged(pathComponents: Array<String>)
}

class MILWebViewController : UIViewController, UIWebViewDelegate{
    var webView : UIWebView = UIWebView()
    var delegate : MILWebViewDelegate?
    var startPage : String = "index.html"
    var fragment : String = ""
    var currentURL: NSURLRequest?
    
    let MIL_URL_SEPARATOR = "/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        self.view.addSubview(webView)
        webView.layer.zPosition = -1

        let bundle : NSBundle = NSBundle.mainBundle()
        var urlParts = startPage.componentsSeparatedByString(MIL_URL_SEPARATOR)
        
        if(urlParts.count == 0){
            return
        }else{
            fragment = buildFragment(urlParts)
            let url : NSURL = NSURL(fileURLWithPath: bundle.pathForResource(urlParts[0], ofType: nil)!, isDirectory: false)
            let fullUrl : NSURL = NSURL(string: MIL_URL_SEPARATOR + fragment, relativeToURL: url.absoluteURL)!
            print("full path to start page was \(fullUrl.absoluteString)")
            currentURL = NSURLRequest(URL: url)
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func buildFragment(parts: Array<String>) -> String{
        var fullFragment : String = parts[1]
        
        if(parts.count > 2){
            for(var i=2;i < parts.count; i++){
                fullFragment = fullFragment + "/" + parts[i]
            }
        }
        
        return fullFragment
    }
    
    func setupWebViewConstraints(){
        let bindings = ["webView": webView]
        
        let verticalConstraints : String = "V:|-0-[webView]-0-|"
        let horizontalConstraints : String = "H:|-0-[webView]-0-|"
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.removeConstraints(webView.constraints)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(horizontalConstraints, options: [], metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(verticalConstraints, options:[], metrics: nil, views: bindings))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(fragment != ""){
            webView.stringByEvaluatingJavaScriptFromString("window.location.hash = '\(fragment)'")
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("loaded URL: \(request.URL!.fragment)")
        
        let path = request.URL!.fragment
        
        if path == nil{
            return true
        }
        
        let pathStr : String = path! as String
        var pathItems : Array<String>? = pathStr.componentsSeparatedByString("/")
        if(pathItems == nil || pathItems?.count <= 2){
            return true
        }
        
        let mainRoute : String? = pathItems?[1]
        
        switch(mainRoute!){
        case "WebView":
            print("MILWebView - HTML content called ShowContent")
            if let del = delegate {
                del.webViewHasChanged?(pathItems!)
            }
            break
            
        case "NativeView":
            if(pathItems?.count < 3){
                print("MILWebView ERROR: didn't specify a ViewController in the correct syntax.  For example: /ViewController/NextView")
                return false
            }

            if let del = delegate {
                del.nativeViewHasChanged?(pathItems!)
            }
            
            break
        default:
            break
        }
        
        return true
    }
    
}