import SpriteKit

// Subclasse Player
class Player: SKNode {
    //Todos os 'Personagens' possuem atributos
    let spriteNode: SKSpriteNode //Um sprite atrelado
    let idleAnimation: [SKTexture] //Uma animação parado
    let walkAnimation: [SKTexture] //Uma animacão em movimento
    
    //O esqueleto dos atributos é iniciado
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
    
    func playWalkAnimation() {
        spriteNode.run(SKAction.repeatForever(SKAction.animate(with: walkAnimation, timePerFrame: 0.1)))
    }
    //A classe player possuie todos os atributos caracteristicas e capacidades de sua mãe, mas também possue suas proprias particularidades que seu "irmão" NPC não possuie. como poder se mover para direita e esquerda.
    private var isMoving = false

    func move(direction: CGVector) {
        self.position.x += direction.dx
        if !isMoving {
            playWalkAnimation()
            isMoving = true
        }
        // Ajusta a orientação com base no movimento
        spriteNode.xScale = direction.dx > 0 ? 1 : -1
    }

    //Função para ele voltar para animação de idle após terminar de se mover
    func stop() {
        if isMoving {
            playIdleAnimation()
            isMoving = false
        }
    }
}
