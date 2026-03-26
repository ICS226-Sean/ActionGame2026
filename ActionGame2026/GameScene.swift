import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var sprite : SKSpriteNode!
    var scoreLabel:SKLabelNode!
    
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10
    let opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score : \(score) "
        }
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 45
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        
        self.addChild(scoreLabel)
        
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sprite.size = CGSize(width: 50, height: 50)
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        self.physicsWorld.contactDelegate = self
        
        opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(opponentSprite)
        let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1)
        let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 1)
        let movement = SKAction.sequence([downMovement, upMovement])
        moveOpponent()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        score += 1
        print("Hit!")
    }
    func touchDown(atPoint pos : CGPoint) {
        
    }
    func touchMoved(toPoint pos : CGPoint) {
    }
    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func update(_ currentTime: TimeInterval) {
    }
    func moveOpponent() {
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        let randomY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.height))
        let movement = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 1)
        opponentSprite.run(movement, completion: { [unowned self] in
            self.moveOpponent()
        })
    }
    
}
