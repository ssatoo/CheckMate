//
//  PhotoViewController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 09/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var userName = "-1"
    var userID = "4"
    var theImage : UIImage? = nil
    
   
    
    
    
    @IBAction func ShareBtnAction(sender: AnyObject) {
      
         if (utility.getLogInStatus() ) {
       
        
        let url :NSURL = NSURL(string:  utility.ServiceRequest("addPhotos.php?UID=\(userID))"))!
        print("\(url)")
      self.imageUploadRequest(imageView: self.imageview, uploadUrl: url  , param: ["usersID" : "4"])
        
         }else{
          
                let appWindow = UIApplication.sharedApplication().delegate?.window!
                appWindow!.makeToast(message: "You must log in to share photo")
            
        
        }
        
    }
    @IBAction func cancelBtnAction(sender: AnyObject) {
        
    }
    @IBOutlet var imageview: UIImageView!
    
    override func viewDidLoad() {
        self.imageview.image = theImage
       // print(utility.getUser())
        let userItem = utility.getUser()
        if (userItem.userName != nil) {
        userName = userItem.userName
        userID = userItem.userId
            print("uname: \(userName), ID\(userID)")
        }
        
    }
    
    func imageUploadRequest(imageView imageView: UIImageView, uploadUrl: NSURL, param: [String:String]?) {
        
           let request = NSMutableURLRequest(URL:uploadUrl);
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(theImage!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "imageName", imageDataKey: imageData!, boundary: boundary)
        
        //myActivityIndicator.startAnimating();
        
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request,
                                                                     completionHandler: {
                                                                        (data, response, error) -> Void in
                                                                        if let data = data {
                                                                            
                                                                            // You can print out response object
                                                                            print("******* response = \(response)")
                                                                            
                                                                            print(data.length)
                                                                            // you can use data here
                                                                            
                                                                            // Print out reponse body
                                                                            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                                                                            print("****** response data = \(responseString!)")
                                                                            
                                                                            
                                                                            
                                                                            let string = responseString!.componentsSeparatedByString("endspot")
                                                                           
                                                                                let firstPart = string[0]
                                                                                print(firstPart) // print Hello
                                                                            
                                                                            
                                                                            
                                                                            if let data = firstPart.dataUsingEncoding(NSUTF8StringEncoding) {
                                                                                var error: NSError?
                                                                                let json =  try!NSJSONSerialization.JSONObjectWithData(data, options:[  .AllowFragments , .MutableContainers]) as? NSDictionary;                                                                                print("\(json)")
                                                                            }
                                                                            
                                                                            
                                                                            
                                                                           // let json =  try!NSJSONSerialization.JSONObjectWithData(data, options:[  .AllowFragments , .MutableContainers]) as? NSDictionary
                                                                            
                                                                          //  print("json value \(json)")
                                                                            
                                                                            //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(),{
                                                                                //self.myActivityIndicator.stopAnimating()
                                                                                //self.imageView.image = nil;
                                                                            });
                                                                            
                                                                        } else if let error = error {
                                                                            print(error.description)
                                                                        }
        })
        task.resume()
        
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
         let timestamp = NSDate().timeIntervalSince1970 * 1000
        
        let aString: String = "\(timestamp)"
        let newString = aString.stringByReplacingOccurrencesOfString(".", withString: "")
        
        let imageName: String = "\(userName)_\(newString).jpg"
        // var image = UIImage(named: imageName)
        
        
        let filename = imageName
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
// extension for impage uploading

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
    
    
    
    

