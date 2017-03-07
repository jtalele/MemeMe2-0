//
//  SavedMemeTableViewController.swift
//  MemeMe
//
//  Created by Jitendra Talele on 4/30/16.
//  Copyright © 2016 Talele. All rights reserved.
//

import UIKit

class SavedMemeTableViewController: UITableViewController {

    //Mark:View components declarations
    @IBOutlet var savedMemeTableView: UITableView!
    
    
    //MARK:Custom Declarations
    
    var savedMemes:[Meme]?
    let appDelegate=UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK:View Methods

    
    override func viewWillAppear(_ animated: Bool) {

        savedMemes=appDelegate.savedMemes

        savedMemeTableView.reloadData()
    }
    
    //MARK:tableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! SavedMemeTableCell
        
        
        if(savedMemes!.count>0)
        {
            

            myCell.cellImage.image=savedMemes![indexPath.row].memedImage
            myCell.cellLabel.text=savedMemes![indexPath.row].topText + "..." + savedMemes![indexPath.row].bottomText
        }
        
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.myMeme = self.savedMemes![indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
        
    }

}















