//
//  GameScene.swift
//  DRGlyphLabelNodeDemo
//
//  Created by Alfred on 14/11/23.
//  Copyright (c) 2014年 Mogo Studio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        let myGlyphLabel = DRGlyphLabelNode()
        myGlyphLabel.font = DRGlyphFont(name: "font1")
        myGlyphLabel.text = "123456789"
        myGlyphLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myGlyphLabel)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
