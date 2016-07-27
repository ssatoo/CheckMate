//
//  hystoryTableViewController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 05/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit



class hystoryTableViewController: UITableViewController {
    
    
    var photosArr: [Photo] = []
    var selectedItem : Photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Photo list"
        self.tableView.delegate =  self
        //self.tableView.reloadData()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.view.makeToastActivity()
        self.view.userInteractionEnabled = false
         self.getPhotosRequest()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosArr.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if utility.getLogInStatus() {
        
            selectedItem = photosArr[indexPath.row]
            performSegueWithIdentifier("votePhotoSegue", sender: self)
        }else{
        
            
            let appWindow = UIApplication.sharedApplication().delegate?.window!
            appWindow!.makeToast(message: "You must log in first")
        

        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Votecells") as? Votecells
        
        if cell == nil {
            cell = Votecells(style: UITableViewCellStyle.Value1, reuseIdentifier: "Votecells")
        }

        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        let itemPhoto = photosArr[indexPath.row]
        cell?.imageForVote.makeToastActivity()
        cell?.imageForVote.tag = indexPath.row
        utility.loadImageFromUrl(itemPhoto.path, view: cell!.imageForVote , tag: indexPath.row)
        
       // itemPhoto.SharedImage = cell!.imageForVote.image
        cell!.upVoteLbl.text = "\(itemPhoto.upVotes)"
        cell!.downVoteLbl.text = "\(itemPhoto.downVotes)"
        return cell!
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "votePhotoSegue" {
            let viewController: votePhoteViewController = segue.destinationViewController as! votePhoteViewController
            
           viewController.item = selectedItem
            
            
            
        }
    }
    
    func getPhotosRequest() {
        
        photosArr.removeAll()
       // let postString = "uname=\(self.userNameTxt.text!)&pass=\(self.userPassTxt.text!)"
        let url = utility.ServiceRequest("getPhotos.php")
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
               // print("statusCode should be 200, but is \(httpStatus.statusCode)")
               // print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
             //print("responseString = \(responseString!)")
            
            
            let string = responseString!.componentsSeparatedByString("endspot")
            
            let firstPart = string[0]
            //print("first \(firstPart)") // print Hello
           
            if let data = firstPart.dataUsingEncoding(NSUTF8StringEncoding) {
               // var error: NSError?
                let json =  try!NSJSONSerialization.JSONObjectWithData(data, options:[  .AllowFragments , .MutableContainers]) as? NSDictionary;                                                                                //print("\(json)")
                
                
                let photos = json!["photos"]
                //print("photos array \(photos)")
                
                for (var i :Int = 0; i < photos?.count; i += 1) {
                    
                    let item :Photo = Photo()
                    let dict = photos?.objectAtIndex(i) as? NSDictionary
                    item.timestamp = dict?.valueForKey("dateUploaded") as! String
                    item.downVotes = dict?.valueForKey("downvotes") as! String
                    item.upVotes = dict?.valueForKey("upvotes") as! String
                    item.photoID = dict?.valueForKey("id") as! String
                    item.path = dict?.valueForKey("path") as! String
                    item.userId = dict?.valueForKey("userID") as! String
                    
                    self.photosArr.append(item)
                
                }
                
              print("photos count (\(self.photosArr.count))")
                 dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                    self.view.hideToastActivity()
                    self.view.userInteractionEnabled = true
                }
            }

          
            
            
            
        }
        task.resume()
        
    }

    }
