//
//  GameScene.swift
//  EatDaBall
//
//  Created by Denis Thamrin on 3/07/2014.
//  Copyright (c) 2014 Denis Thamrin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    
    // maybe let monster as instance variable to check for collision ?
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*create background */
        createBackground()
        createMonster()
        setGravity()
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("spawnBall"), userInfo: nil, repeats: true)
        
  

        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "World of Balls!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            var projectile = SKSpriteNode(imageNamed: "cookie.png")
            projectile.position = CGPoint(x: CGRectGetMidX(self.frame),y:CGRectGetMinY(self.frame) + 100)
            projectile.zPosition = 1
            var targetX = location.x
            var targetY = location.y
            //if (location.x < CGRectGetMidX(self.frame)){
             //   targetX = -targetX
            //} else if (location.x == CGRectGetMidX(self.frame)){
             //   targetX = targetX * 0
            //}
            
            //targetX *= CGRectGetMidX(self.frame)
            //targetY *= CGRectGetMidY(self.frame)
            var target = CGPoint(x: targetX,y:targetY)
            //TODO add completion
            projectile.runAction(SKAction.moveTo(target,duration: 1))
            
            //add physics to the shape we just created
            setPhysicsX(projectile)
            projectile.physicsBody.categoryBitMask = 2
            self.addChild(projectile)
            
            //TODO should add height detection that remove the object at the maximum height
            //if(projectile.position.y > targetY/2){
            //    projectile.removeFromParent()
            //    NSLog("%s", "lolool")
            //}
        }
    }
   

    
    /* create Background */
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "main_background.png")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
    }
    
    // create the funny cookie monster !
    func createMonster(){
        let monster = SKSpriteNode(imageNamed: "monster.png")
        monster.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMinY(self.frame))
        monster.xScale = 0.1
        monster.yScale = 0.1
        monster.zPosition = -1
        self.addChild(monster)
    }
    
    func setGravity(){
        //self.physicsWorld.gravity = CGVectorMake(0, -1)
        let physicsBody = SKPhysicsBody (edgeLoopFromRect: self.frame)
        self.physicsBody = physicsBody
    }
    // add physics to the body
    // add ball drop actually
    func setPhysics(shape:SKShapeNode){
        
        //add physics to the shape we just created
        shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.frame.size.width/2)
        shape.physicsBody.friction = 0.3
        shape.physicsBody.restitution = 0.8
        shape.physicsBody.mass = 0.5
        shape.physicsBody.allowsRotation = false
        
        //TODO make the ball move slower
        shape.runAction(SKAction.moveByX(20 ,y:200, duration: 1))
    }
    // for skSprite node
    func setPhysicsX(shape:SKSpriteNode){
        
        //add physics to the shape we just created
        shape.physicsBody = SKPhysicsBody(circleOfRadius: shape.frame.size.width/2)
        shape.physicsBody.friction = 1
        //shape.physicsBody.restitution = 0.8
        //shape.physicsBody.mass = 0.1
        shape.physicsBody.allowsRotation = false

        //TODO make the ball move slower
        //shape.runAction(SKAction.moveByX(0 ,y:200, duration: 1000))
    }
    
    /* spawn a single ball in a random location */
    /* http://www.bytearray.org/?p=5314 */
    func spawnBall(){
        let shape = SKShapeNode(circleOfRadius: 20)
        shape.strokeColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        shape.lineWidth = 4
        shape.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        shape.zPosition = 1
        
        var randomX = CGFloat(random())
        //TODO should change constant to constant that is defined by ball width
        randomX = randomX % ( CGRectGetMaxX(self.frame) - 200) + 100
        shape.position = CGPoint(x:randomX,y:CGRectGetMaxY(self.frame))
        
        setPhysics(shape)
        shape.physicsBody.categoryBitMask = 1
        self.addChild(shape)

    }
    
    //Protocol declaration
    func didBeginContact(contact: SKPhysicsContact){
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        
        if(contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 || (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) ){
            NSLog("%s", "lolool")
            
        } else if(contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 1) {
            return
        } else if(contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 2) {
            return
        }
        
        var ball:SKSpriteNode = contact.bodyA.node as SKSpriteNode
        var cookie:SKSpriteNode = contact.bodyB.node as SKSpriteNode
        ball.removeFromParent()
        cookie.removeFromParent()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    //override func update(currentTime: CFTimeInterval) {    }
    
}
