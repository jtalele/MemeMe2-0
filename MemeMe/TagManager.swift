//
//  TagManager.swift
//  MemeMe
//
//  Created by Jitendra Talele on 4/27/16.
//  Copyright © 2016 Talele. All rights reserved.
//

class TagManager{
    
    
   func getTagIdForName(_ itemName:String)->Int
    {
        var tagId=0
        
        if(itemName=="TOP_TEXTFIELD"){
            tagId=1001
        }
        if(itemName=="BOTTOM_TEXTFIELD"){
            tagId=1002
        }
        if(itemName=="CAMERA_BUTTON"){
            tagId=1003
        }
        if(itemName=="ALBUMS_BUTTON"){
            tagId=1004
        }

        return tagId
    }
    
    
    
    
}
