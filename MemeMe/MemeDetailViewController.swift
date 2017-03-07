//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jitendra Talele on 5/1/16.
//  Copyright © 2016 Talele. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    //MARK:View Variable Declarations
    @IBOutlet weak var memeImage: UIImageView!
    

    //MARK:Custom Variable Declarations
    var myMeme:Meme?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImage.image=myMeme?.memedImage
 
        self.tabBarController?.tabBar.isHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden=false
    }

}
