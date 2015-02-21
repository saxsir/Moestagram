//
//  ViewController.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/02/21.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var launchCameraButton: UIBarButtonItem!

    @IBAction func launchCameraButtonTapped(sender: UIBarButtonItem) {
        let camera = UIImagePickerControllerSourceType.Camera

        if (UIImagePickerController.isSourceTypeAvailable(camera)) {
            println("camera is available")
        } else {
            println("no camera available")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

