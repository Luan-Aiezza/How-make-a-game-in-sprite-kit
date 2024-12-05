import SpriteKit
import AVFoundation

//A cena onde toda a parte audiovisual acontece para o usuário
@MainActor
class GameScene: SKScene {
    // Rastreador de contato
    private var isPlayerContactWithNPC = false

    // Áudio
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var npcSoundPlayer: AVAudioPlayer?
    
    //Declaramos as variaveis e constantes que usaremos e os objetos que elas irão criar
    let cameraNode = SKCameraNode()
    var player: Player! //
    var npc: NPC!
    var isMovingRight = false
    var isMovingLeft = false
    
    //Funcão principal
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self // Delegado para detecção de contato

        // Configurar música de fundo
        playBackgroundMusic(named: "background_music.mp3")
        
        //Mapeamento dos sprites do player quando está parado
        let playerIdleTextures = (1...4).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "playerIdle\(index)")
            texture.filteringMode = .nearest // ou .linear, dependendo do efeito desejado
            return texture
        }
        
        //Mapeamento dos sprites quando o player está em movimento
        let playerWalkTextures = (1...3).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "playerWalk\(index)")
            texture.filteringMode = .nearest
            return texture
        }

        //Mapeamento dos sprites quando o NPC está parado
        let npcTextures = (1...3).map { index -> SKTexture in
            let texture = SKTexture(imageNamed: "NpcIdle\(index)")
            texture.filteringMode = .nearest
            return texture
        }
        
        //PLAYER: aqui é onde instanciamos o nosso Player na cena
        player = Player(idleTextures: playerIdleTextures, walkTextures: playerWalkTextures)
        player.position = CGPoint(x: 0, y: 0)
        player.setScale(5)
        
        // Ajuste as máscaras de categoria
        player.spriteNode.physicsBody?.categoryBitMask = 0x1 << 1 // Player
        player.spriteNode.physicsBody?.contactTestBitMask = 0x1 << 2 // Detecção de contato com NPC
        
        addChild(player)
        
        //NPC: aqui instanciamos o nosso NPC na cena
        npc = NPC(idleTextures: npcTextures, walkTextures: npcTextures)
        npc.position = CGPoint(x: 700, y: 0)
        npc.setScale(5)
        
        npc.spriteNode.physicsBody?.categoryBitMask = 0x1 << 2 // NPC
        npc.spriteNode.physicsBody?.contactTestBitMask = 0x1 << 1 // Detecção de contato com Player
        
        addChild(npc)
        
        //CAMERA: aqui instanciamos uma camera na cena para acompanhar o player
        cameraNode.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        camera = cameraNode // Define a câmera da cena
        
    }
    
    //Esta função ira realizar algo sempre que o usuario estiver tocando na tela
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

    //Esta funcão ira realizar algo sempre que o toque da função anterior terminar
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMovingRight = false
        isMovingLeft = false
        player.stop()
    }

    //A função de update é muito importante, pois ela que é responsavel por atualizar a informação para o usuario
    override func update(_ currentTime: TimeInterval) {
        self.camera?.run(.moveTo(x: player?.position.x ?? 0, duration: 0.3))
        
//        print(player.position.x)
        
        // Move o jogador com base no estado dos toques
        if isMovingRight {
            player.move(direction: CGVector(dx: 100 * CGFloat(3.0/60.0), dy: 0))
        } else if isMovingLeft {
            player.move(direction: CGVector(dx: -100 * CGFloat(3.0/60.0), dy: 0))
        } else {
            // Para o movimento quando não há input
            player.stop()
        }
    }
    
    private func playBackgroundMusic(named filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { return }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Repetir indefinidamente
            backgroundMusicPlayer?.play()
            backgroundMusicPlayer?.volume = 1
        } catch {
            print("Erro ao reproduzir música de fundo: \(error.localizedDescription)")
        }
    }
    
    private func playNpcSound(named filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { return }
        do {
            npcSoundPlayer = try AVAudioPlayer(contentsOf: url)
            npcSoundPlayer?.play()
        } catch {
            print("Erro ao reproduzir som do NPC: \(error.localizedDescription)")
        }
    }
}

extension GameScene: @preconcurrency SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Identifica os corpos em contato
        let bodyA = contact.bodyA.node as? SKSpriteNode
        let bodyB = contact.bodyB.node as? SKSpriteNode
        
        if (bodyA == player.spriteNode && bodyB == npc.spriteNode) ||
           (bodyB == player.spriteNode && bodyA == npc.spriteNode) {
            // Mostra o balão de diálogo quando há contato
            npc.showDialogBalloon()
            playNpcSound(named: "npc_interaction.mp3")
//            self.camera?.isPaused = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // Identifica os corpos que terminaram o contato
        let bodyA = contact.bodyA.node as? SKSpriteNode
        let bodyB = contact.bodyB.node as? SKSpriteNode
        
        if (bodyA == player.spriteNode && bodyB == npc.spriteNode) ||
           (bodyB == player.spriteNode && bodyA == npc.spriteNode) {
            // Remove o balão de diálogo quando o contato termina
            npc.hideDialogBalloon()
            /*self.camera?.isPaused = false*/ //CHECAR DEPOIS
        }
    }
}
