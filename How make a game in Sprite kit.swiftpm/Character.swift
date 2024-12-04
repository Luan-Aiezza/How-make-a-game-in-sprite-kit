import SpriteKit

// Classe base
class Character: SKNode {
    let spriteNode: SKSpriteNode
    let idleAnimation: [SKTexture]
    let walkAnimation: [SKTexture]
    
    init(idleTextures: [SKTexture], walkTextures: [SKTexture]) {
        self.spriteNode = SKSpriteNode(texture: idleTextures.first)
        self.idleAnimation = idleTextures
        self.walkAnimation = walkTextures
        
        super.init()
        addChild(spriteNode)
        setupPhysicsBody()
        playIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.allowsRotation = false
        spriteNode.physicsBody?.categoryBitMask = 0x1 << 1
        spriteNode.physicsBody?.collisionBitMask = 0x1 << 1
        spriteNode.physicsBody?.contactTestBitMask = 0x1 << 0
    }
    
    func playIdleAnimation() {
        spriteNode.run(SKAction.repeatForever(SKAction.animate(with: idleAnimation, timePerFrame: 0.1)))
    }
    
    func playWalkAnimation() {
        spriteNode.run(SKAction.repeatForever(SKAction.animate(with: walkAnimation, timePerFrame: 0.1)))
    }
}

// Subclasse Player
class Player: Character {
    func move(direction: CGVector) {
        self.position.x += direction.dx
        playWalkAnimation()
    }
}

// Subclasse NPC
class NPC: Character {
    
}
