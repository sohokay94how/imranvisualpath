//
//  ViewController.swift
//  SwiftJavaScript
//
//  Created by hengchengfei on 16/2/1.
//  Copyright © 2016年 chengfeisoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didClickH5(){
        let vc = H5ViewController.init(url: nil, callbackHandlerName: ["callbackHandler"]) { (handlerName, sendData, vc) -> Void in
            if "callbackHandler" == handlerName {
                let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ThirdViewController") as! ThirdViewController
                print(sendData)
                
                vc.navigationController?.pushViewController(thirdVC, animated: true)
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

