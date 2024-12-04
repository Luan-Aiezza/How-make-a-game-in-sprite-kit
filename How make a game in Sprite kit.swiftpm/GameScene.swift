import SpriteKit

class GameScene: SKScene {
    
    let cameraNode = SKCameraNode()
    var player: Player!
    var npc: NPC!
    var isMovingRight = false
    var isMovingLeft = false
    
    override func didMove(to view: SKView) {
        let playerIdleTextures = (1...4).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "playerIdle\(index)")
            texture.filteringMode = .nearest // ou .linear, dependendo do efeito desejado
            return texture
        }

        let playerWalkTextures = (1...3).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "playerWalk\(index)")
            texture.filteringMode = .nearest
            return texture
        }

        let npcTextures = (1...3).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "NpcIdle\(index)")
            texture.filteringMode = .nearest
            return texture
        }
        
        //PLAYER
        player = Player(idleTextures: playerIdleTextures, walkTextures: playerWalkTextures)
        player.position = CGPoint(x: 0, y: 0)
        player.setScale(5)
        addChild(player)
        
        //NPC
        npc = NPC(idleTextures: npcTextures, walkTextures: npcTextures)
        npc.position = CGPoint(x: 700, y: 0)
        npc.setScale(5)
        addChild(npc)
        
        //CAMERA
        cameraNode.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        camera = cameraNode // Define a câmera da cena
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: camera!)

            // Determina a direção com base na metade da tela
            if location.x >= 0 {
                isMovingRight = true
                isMovingLeft = false
                print("direita")
                
            } else if location.x < 0{
                isMovingRight = false
                isMovingLeft = true
                print("esquerda")
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Para o movimento quando o toque termina
        isMovingRight = false
        isMovingLeft = false
        
    }

    override func update(_ currentTime: TimeInterval) {

        self.camera?.run(.moveTo(x: player?.position.x ?? 0, duration: 0.3))
        
        print(player.position.x)
        
        // Move o jogador com base no estado dos toques
        if isMovingRight {
            player.move(direction: CGVector(dx: 100 * CGFloat(3.0/60.0), dy: 0)) // Ajusta velocidade por frame

        } else if isMovingLeft {
            player.move(direction: CGVector(dx: -100 * CGFloat(3.0/60.0), dy: 0))
        }
    }
}
