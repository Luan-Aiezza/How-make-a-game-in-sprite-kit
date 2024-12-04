import SwiftUI
import SpriteKit

// ContentView: integra o SpriteKit com SwiftUI
struct ContentView: View {
    var body: some View {
        SpriteView(scene: mainGameScene())
            .ignoresSafeArea() // Faz o SpriteView ocupar a tela inteira
    }
    
    // Função para criar a cena configurada
    private func mainGameScene() -> SKScene {
        let scene = GameScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
        scene.scaleMode = .resizeFill
        return scene
    }
}
