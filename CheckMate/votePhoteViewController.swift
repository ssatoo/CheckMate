//
//  votePhoteViewController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 11/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class votePhoteViewController: UIViewController {

    var item : Photo!
   
    
    @IBOutlet var closeView: UIButton!
    
    @IBAction func closeBtnAction(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    @IBAction func downVoteBtnAction(sender: AnyObject) {
        //votePhoto.php
          if utility.getLogInStatus() {
        print("usrID = \(utility.getUser().userId)")
        self.canVote(item.photoID, vote: "-1",uID: utility.getUser().userId)
        
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }else{
    
    let appWindow = UIApplication.sharedApplication().delegate?.window!
    appWindow!.makeToast(message: "You must log in to vote photos")
    }

    }
    @IBAction func upvoteBtnAction(sender: AnyObject) {
        //votePhoto.php
     
        if utility.getLogInStatus() {
        print("usrID = \(utility.getUser().userId)")
        self.canVote(item.photoID, vote: "1",uID: utility.getUser().userId)
            self.navigationController!.popViewControllerAnimated(true)
        
        }else{
        
            let appWindow = UIApplication.sharedApplication().delegate?.window!
            appWindow!.makeToast(message: "You must log in to vote photos")
        }
    }
    @IBOutlet var imageForVote: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageForVote.makeToastActivity()
        self.title = "Vote Photo"
        
        utility.loadImageFromUrl(item.path, view: self.imageForVote ,tag: 0)
        // itemPhoto.SharedImage = cell!.imageForVote.image
       
        
    }
    
    
    
    
    func VoteRequest(imageID : String ,vote : String ) {
        
        
        let postString = "imageID=\(imageID)&vote=\(vote)&UserID=\(utility.getUser().userId)"
        let url = utility.ServiceRequest("votePhoto.php?\(postString)")
        print("request url \(url)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        
        //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")

        }
        task.resume()
    }

    
    func canVote(imageID : String ,vote : String,uID : String) {
        
        let firstPart :String!
        let postString = "PhotoID=\(imageID)&UserID=\(uID)"
        let url = utility.ServiceRequest("votesAction.php?\(postString)")
        print("request url \(url)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        
        //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            
            let string = responseString!.componentsSeparatedByString("endspot")
            
            let firstPart = string[0]
         
            
            print("can vote \(firstPart)")
            
            if self.canVoteResponse(firstPart) == "-1"{
                 print("You vote this photo")
                  dispatch_async(dispatch_get_main_queue()) {
                    let appWindow = UIApplication.sharedApplication().delegate?.window!
                     appWindow!.makeToast(message: "You cant vote Images more tha one times")
                }
            
            }else if self.canVoteResponse(firstPart) == "1"{
                self.VoteRequest(self.item.photoID, vote: vote)
               
            
            }

            
        }
        task.resume()
    }

    func canVoteResponse (response : String) -> String {
        return response
    }
    
}
