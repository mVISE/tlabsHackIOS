//
//  StartScanViewController.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit
import AVFoundation

class StartScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

  var captureSession = AVCaptureSession()
  
  var videoPreviewLayer:AVCaptureVideoPreviewLayer?
  var qrCodeFrameView:UIView?
  var lastScanned: String?
  
  var user: User?
  
  var stopUpdates = false
  
  @IBOutlet weak var scanView: UIView!
  @IBOutlet weak var scoreLabel: UILabel!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
        if granted {
        } else {
          let message = "need cam access"
          let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (_) in
            self.navigationController?.popToRootViewController(animated: true)
          }))
          self.present(alert, animated: true, completion: nil)
        }
      })
      
      let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
      
      guard let captureDevice = deviceDiscoverySession.devices.first else {
        print("Failed to get the camera device")
        return
      }
      
      do {
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input = try AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        var captureArray = [AVMetadataObject.ObjectType]()
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.qr) {
          captureArray.append(AVMetadataObject.ObjectType.qr)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code128) {
          captureArray.append(AVMetadataObject.ObjectType.code128)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code128) {
          captureArray.append(AVMetadataObject.ObjectType.code128)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.ean8) {
          captureArray.append(AVMetadataObject.ObjectType.ean8)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.ean13) {
          captureArray.append(AVMetadataObject.ObjectType.ean13)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code39) {
          captureArray.append(AVMetadataObject.ObjectType.code39)
        }
        
        if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code93) {
          captureArray.append(AVMetadataObject.ObjectType.code93)
        }
        
        captureMetadataOutput.metadataObjectTypes = captureArray
        
        
      } catch {
        // If any error occurs, simply print it out and don't continue any more.
        print(error)
        return
      }
      
      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      videoPreviewLayer?.frame = self.scanView.layer.bounds
      self.scanView.layer.addSublayer(videoPreviewLayer!)
      
      
      if qrCodeFrameView == nil {
        qrCodeFrameView = UIView()
        qrCodeFrameView!.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView!.layer.borderWidth = 2
        self.scanView.addSubview(qrCodeFrameView!)
        self.scanView.bringSubviewToFront(qrCodeFrameView!)
      }
    }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    captureSession.startRunning()
    self.stopUpdates = false
    self.reloadScore()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.stopUpdates = true
  }
  
  var index = 0
  
  func reloadScore() {
    BackendConnection().getUser(userID: (UIDevice.current.identifierForVendor?.uuidString)!) { (user, error) in
      guard let user = user else { return }
      self.user = user
      DispatchQueue.main.async {
        self.scoreLabel.text = "\(user.score)"
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        if !self.stopUpdates {
          self.reloadScore()
        }
      })
    }
  }
  
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
    captureSession.stopRunning()
    
    if metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
      return
    }
    
    // Get the metadata object.
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    guard let scannedString = metadataObj.stringValue else {
      print("Scanned empty String")
      captureSession.startRunning()
      return
    }
    
    print(scannedString)
    lastScanned = scannedString
    
    self.openItemInteraction()
  }
  
  func openItemInteraction() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "ItemInteraction") as! ItemInteractionViewController
    vc.scannedItemString = self.lastScanned!
    vc.user = self.user
    
    self.show(vc, sender: self)
//    self.present(controller, animated: true, completion: nil)
  }
}
