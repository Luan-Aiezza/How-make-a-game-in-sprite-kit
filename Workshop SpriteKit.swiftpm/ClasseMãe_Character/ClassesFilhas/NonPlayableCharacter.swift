import SpriteKit

class NPC: Character {
    private var dialogBalloon: SKSpriteNode?
    
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
