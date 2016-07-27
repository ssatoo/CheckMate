//
//  SecondViewController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 05/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit
import AVFoundation
class SecondViewController: UIViewController  {
    var isFrontCamera : Bool = false
    var image :UIImage!
    let session: AVCaptureSession  = AVCaptureSession()
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet var sharePhotoBtn: UIButton!
    @IBOutlet var takePhotoBtn: UIButton!
    @IBOutlet var optionsView: UIView!
    @IBOutlet var CameraView: UIView!
 
    @IBOutlet var takenPhoto: UIImageView!
    @IBOutlet var changeCameraBtn: UIButton!
    @IBAction func PreviewPhotoBtn(sender: AnyObject) {
        
        
        
        
    }
    @IBAction func changeCameraBtnAction(sender: AnyObject) {
        
        
        self.reloadCamera()
        
    }
    @IBAction func takePhotoBtn(sender: AnyObject) {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                // ...
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                     self.image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    // ...
                    self.takenPhoto.image = self.image
                }
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Check Mate"
        
        self.takePhotoBtn.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        
        self.sharePhotoBtn.layer.cornerRadius = 10
        view.layer.masksToBounds = true;

        self.optionsView.layer.borderColor = UIColor.blackColor().CGColor
        self.optionsView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        
      
        self.view.layoutIfNeeded()
        self.reloadviews(self.view)

       
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
       // let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
       
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Front {
                captureDevice = device
                isFrontCamera =  true
                break
            }
        }
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        
        if error == nil && session.canAddInput(input) {
            session.addInput(input)
            // ...
            // The remainder of the session setup will go here...
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
            // ...
            // Configure the Live Preview here...
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
            CameraView.layer.addSublayer(videoPreviewLayer!)
            session.startRunning()

        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // print("\(CameraView)")
        videoPreviewLayer!.frame = CameraView.bounds
        
        CameraView.setNeedsLayout()
        CameraView.layoutIfNeeded()
    }
    
    
    
    func reloadviews (view :UIView) {
        
        for sview :UIView in view.subviews {
           // print("\(sview.description)")
           
            sview.layoutIfNeeded()
            reloadviews(sview)
            
        }
        view.layoutIfNeeded()
        view.layoutSubviews()
        return
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhotoSegue" {
            let viewController: PhotoViewController = segue.destinationViewController as! PhotoViewController
           
            viewController.theImage = self.image;
            //viewController.pinCode = self.exams[indexPath.row]
            
        }
    }
    
    
    func reloadCamera() {
        // camera loading code
        session.stopRunning()
       
        videoPreviewLayer?.removeFromSuperlayer()
        
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
    print("camera \(isFrontCamera)")
        
        if (isFrontCamera == false) {
            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            
            
            for device in videoDevices{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device
                    isFrontCamera = true
                    break
                }
            }
        } else {
             let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            for device in videoDevices{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.Back {
                    captureDevice = device
                    isFrontCamera = false
                    break
                }
            }
        }
        
        
        
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }

        
      let oldInput =  session.inputs[session.inputs.count - 1] as! AVCaptureInput
       session.removeInput(oldInput )
        
            session.addInput(input)
        
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        videoPreviewLayer.frame = CameraView.layer.frame
        CameraView.layer.addSublayer(videoPreviewLayer!)
                
                session.startRunning()
        
        
    }
    
}