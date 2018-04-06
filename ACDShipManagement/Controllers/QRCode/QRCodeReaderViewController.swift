
//
//  QRCodeReaderViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-04-01.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var video = AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let barButtonClose = UIBarButtonItem(image: UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(closeView(_:)))
        barButtonClose.tintColor = .white
        self.navigationItem.setLeftBarButton(barButtonClose, animated: true)
        
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        
        do {
            if let captureDeviceUnwrapped = captureDevice {
            let input = try AVCaptureDeviceInput(device: captureDeviceUnwrapped)
            session.addInput(input)
            }

        }
        catch {
            print("Camera access not allowed")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    print(object.stringValue ?? "")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
