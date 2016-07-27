//
//  utility.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 11/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class utility: NSObject {
   
     //var mUser : User = User()
    static var  mUser : User = User()
    static var  isLogin : Bool = false
    
    
    static func ServiceRequest( path: String ) -> String{
     
        let serviceIP = "checkmateapp.net16.net"
        let request = String(format: "http://\(serviceIP)/\(path)")
        return request
        
    }
    
   static func updateUser(username : String , pass : String , ID : String ) -> User{
      
        
        
        mUser.userName = username
        mUser.userId = ID
        mUser.pass = pass
       
        return mUser
        
    }
    
   static func getUser() -> User {
       return mUser
    }
    static func setLogin(_login : Bool){
        isLogin = _login
    }
    
    static func getLogInStatus()->Bool{
        return isLogin
    
    }
    static func loadImageFromUrl(url: String, view: UIImageView , tag: Int){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if tag == view.tag{
                    view.image = UIImage(data: data)
                    
                    view.hideToastActivity()
                    }
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    static func loadImageforCellFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    view.image = UIImage(data: data)
                    //view.hideToastActivity()
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
   
    

}
