//
//  FirstViewController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 05/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UIGestureRecognizerDelegate, UITextFieldDelegate {

    var user : User = User()
    
    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var hiTxt: UILabel!
    @IBOutlet var welcomeView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var userNameTxt: UITextField!
    @IBOutlet var userPassTxt: UITextField!
    
    @IBOutlet var registerView: UIView!
    
    @IBOutlet var rusernameTxt: UITextField!
    
    @IBOutlet var rNameTxt: UITextField!
    
    @IBOutlet var rVerPassTxt: UITextField!
    @IBOutlet var rPassTxt: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginRegSegment: UISegmentedControl!
    @IBAction func login_regSegmentAction(sender: AnyObject) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.loginView.hidden = false
            self.registerView.hidden = true
            break
        case 1:
            self.loginView.hidden = true
            self.registerView.hidden = false
            break
            
        default:
            break
            
        }

        
        
    }
    
    
    @IBAction func logoutBtnAction(sender: AnyObject) {
        
        
        
        self.registerView.hidden = true
        self.loginView.hidden = false
        self.welcomeView.hidden = true
        self.loginRegSegment.hidden = false
         utility.setLogin(false)
        
    }
   
    @IBAction func loginBtnAction(sender: AnyObject) {
        
        self.logInRequest()
        
        
        
        
        
    }
    
    
    @IBAction func registerBtn(sender: AnyObject) {
        
        
        if self.rPassTxt.text == self.rVerPassTxt.text {
            self.regisgterRequest()
        
        }
        
        
    }
   
 
    
    override func viewDidLoad() {
        self.title = "Tab 1"
        super.viewDidLoad()
        
        
        self.loginView.layer.cornerRadius = 10
         view.layer.masksToBounds = true;
        
        self.registerView.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        self.welcomeView.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        
        self.loginBtn.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        
        self.logoutBtn.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        self.registerBtn.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        self.userNameTxt.delegate = self
        self.userPassTxt.delegate = self
        
        self.rNameTxt.delegate = self
        self.rusernameTxt.delegate = self
        
        self.rPassTxt.delegate = self
        self.rVerPassTxt.delegate = self
        
        
        
       // print("\(utility.ServiceRequest("kati allo paei edw"))")
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.togglePreMenu))
        rightSwipeGestureRecognizer.direction =  UISwipeGestureRecognizerDirection.Right
        self.tabBarController?.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        // Add left swipe gesture recognizer
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.toggleNextMenu))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        //sideMenuContainerView.addGestureRecognizer(rightSwipeGestureRecognizer)
        self.tabBarController!.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        
        leftSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if utility.getLogInStatus() == true{
            
            self.registerView.hidden = true
            self.loginView.hidden = true
            self.welcomeView.hidden = false
            self.loginRegSegment.hidden = true
            self.loginRegSegment.selectedSegmentIndex=UISegmentedControlNoSegment
            print("selected index \(self.loginRegSegment.selectedSegmentIndex)")
            
            
        }else{
            self.registerView.hidden = true
            self.loginView.hidden = false
            self.welcomeView.hidden = true
            self.loginRegSegment.hidden = false
            self.loginRegSegment.selectedSegmentIndex = 0
            print("selected index \(self.loginRegSegment.selectedSegmentIndex)")
            
        }
        print("selected index \(self.loginRegSegment.selectedSegmentIndex)")
        
        switch self.loginRegSegment.selectedSegmentIndex {
        case 0:
            self.loginView.hidden = false
            self.registerView.hidden = true
            break
        case 1:
            self.loginView.hidden = true
            self.registerView.hidden = false
            break
            
        default:
            break
            
        }
        
        
     
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toggleNextMenu() {
        print("ENTER SWIPE")
       
        if self.tabBarController?.selectedIndex < 4{
        self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex)! + 1
            print("selectedIndex \(self.tabBarController?.selectedIndex )")
        
     
            
            
       
    }
    }
    func togglePreMenu() {
        print("ENTER SWIPE")
        if self.tabBarController?.selectedIndex != 0{
        self.tabBarController?.selectedIndex = (self.tabBarController?.selectedIndex)! - 1
            print("selectedIndex \(self.tabBarController?.selectedIndex )")}
        
    }
    
    
    func regisgterRequest() {
        
        
         let postString = "name=\(self.rNameTxt.text!)&uname=\(self.rusernameTxt.text!)&pass=\(self.rPassTxt.text!)"
        let url = utility.ServiceRequest("addusers.php?\(postString)")
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
            
            dispatch_async(dispatch_get_main_queue()) {
                //self.tableView.reloadData()
                
                
                self.userPassTxt.resignFirstResponder()
                self.registerView.hidden = true
                self.loginView.hidden = false
                self.welcomeView.hidden = true
               
                
                
                
            }

            
            
            
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    

    
    
    func logInRequest() {
        
        
        let postString = "uname=\(self.userNameTxt.text!)&pass=\(self.userPassTxt.text!)"
        let url = utility.ServiceRequest("LoginUser.php?\(postString)")
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
           // print("responseString = \(responseString!)")
            
            
            
            let string = responseString!.componentsSeparatedByString("endspot")
            
            let firstPart = string[0]
            print("first \(firstPart)") // print Hello
            
            if firstPart == "-1" {
                 utility.setLogin(false)
                print("fail log in")
            }else{
            
                
                
                
                
               
               // self.userPassTxt.resignFirstResponder()
                print("log in with id \(firstPart)")
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    //self.tableView.reloadData()
                    
                    
                    self.userPassTxt.resignFirstResponder()
                    self.registerView.hidden = true
                    self.loginView.hidden = true
                    self.welcomeView.hidden = false
                     self.loginRegSegment.hidden = true
                    self.hiTxt.text = "Hi \(self.userNameTxt.text!)"
                    utility.setLogin(true)
                    
                    
                     self.user = utility.updateUser(self.userNameTxt.text!, pass: self.userPassTxt.text!, ID: firstPart)
                    
                   // self.user.showUser()
                }
                
                
                
            
            }
            
            
        }
        task.resume()
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
}

func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    if let viewController = viewController as? UINavigationController {
        viewController.popToRootViewControllerAnimated(false)
    }
}



