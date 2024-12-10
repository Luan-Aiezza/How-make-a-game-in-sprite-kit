import SpriteKit

class NPC: SKNode {
    private var dialogBalloon: SKSpriteNode?
    
    //Todos os 'Personagens' possuem atributos
    let spriteNode: SKSpriteNode //Um sprite atrelado
    let idleAnimation: [SKTexture] //Uma animação parado
    
    //O esqueleto dos atributos é iniciado
    init(idleTextures: [SKTexture]) {
        self.spriteNode = SKSpriteNode(texture: idleTextures.first)
        self.idleAnimation = idleTextures
        
        super.init()
        addChild(spriteNode)
        setupPhysicsBody()
        playIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Todos os filhos desta classe não apenas herdarão apenas caracteristicas, mas também atributos destas caracteristicas como a física.
    public func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        self.physicsBody?.affectedByGravity = false //gravidade
        self.physicsBody?.allowsRotation = false //permite rotacionar o objeto
        self.physicsBody?.categoryBitMask = 0x1 << 1 // Exemplo: Categoria 1
        self.physicsBody?.contactTestBitMask = 0x1 << 2 // Exemplo: Categoria 2
        //Importante: contato e colisão não são a mesma coisa, a colisão tem uma "massa" e gera um movimento atrelado a mesma.
    }
    
    //As classes filhas também herdarão "capacidades" de sua mãe, como a animação de ficar parado, e a animação de estar em movimento.
    func playIdleAnimation() {
        spriteNode.run(SKAction.repeatForever(SKAction.animate(with: idleAnimation, timePerFrame: 0.1)))
    }
    
    func showDialogBalloon() {
        // Certifique-se de criar o balão apenas uma vez
        if dialogBalloon == nil {
            dialogBalloon = SKSpriteNode(imageNamed: "ballon")
            dialogBalloon?.position = CGPoint(x: 0, y: spriteNode.size.height * 1.5) // Acima do NPC
            dialogBalloon?.texture?.filteringMode = .nearest
            addChild(dialogBalloon!)
        }
    }
    
    func hideDialogBalloon() {
        dialogBalloon?.removeFromParent()
        dialogBalloon = nil//Não há nada aqui
    }
}
