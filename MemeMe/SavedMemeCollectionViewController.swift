//
//  SavedMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jitendra Talele on 4/30/16.
//  Copyright © 2016 Talele. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewController: UICollectionViewController {
   

    //Mark:View components declarations
    
    @IBOutlet weak var savedMemeCollectionView: UICollectionView!
    
    @IBOutlet weak var savedMemeCollectionFlowLayout: UICollectionViewFlowLayout!
    
    
    //MARK:Custom Declarations
    
    var savedMemes:[Meme]?
    let appDelegate=UIApplication.shared.delegate as! AppDelegate
    
    var space:CGFloat?
    var dimension:CGFloat?
    
    //MARK:View Methods

    override func viewDidLoad() {

        space=2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        savedMemeCollectionView.backgroundColor=UIColor.white
        savedMemes=appDelegate.savedMemes
        
        if(UIDevice.current.orientation.isLandscape){
            dimension=(view.frame.size.height-(2*space!))/3.0
        }
        else{
            dimension=(view.frame.size.width-(2*space!))/3.0
        }
        
        savedMemeCollectionFlowLayout.minimumInteritemSpacing=space!
        savedMemeCollectionFlowLayout.itemSize=CGSize(width: dimension!,height: dimension!)
        
        savedMemeCollectionView.reloadData()
 
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if (savedMemeCollectionView != nil) {
            savedMemeCollectionView.backgroundColor=UIColor.white
            savedMemeCollectionView.frame.size=size
        }
        
    }
    

    //MARK:CollectionView Delegate Implementations

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return savedMemes!.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SavedMemeCollectionCell
        
        
        if(savedMemes!.count>0)
        {
            myCell.cellImage.image=savedMemes![indexPath.row].memedImage
           
        }
        
        
        return myCell
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.myMeme = self.savedMemes![indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
        
    }
    
    
    
    
    
    
    
    

}
