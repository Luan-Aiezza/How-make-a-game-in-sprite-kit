import SpriteKit

// Subclasse Player
class Player: Character {
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
