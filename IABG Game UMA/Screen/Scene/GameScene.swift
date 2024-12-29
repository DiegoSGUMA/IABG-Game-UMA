//
//  GameScene.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import SwiftUI
import SpriteKit
import GameKit

final class GameScene: SKScene, ObservableObject {
    
    let randomInt = Int.random(in: 1..<4)
    var backgroundImage = SKSpriteNode()
    var playerBowl = SKSpriteNode()
    var playerPhysisc = SKSpriteNode()
    var fallElement = SKSpriteNode()
    var endLine = SKSpriteNode()
    var gameLevel :levels = .none
    var numbersOfFall: Int = 0
    var countFall: Int = 0
    var repeatFall: TimeInterval = 1
    var bowlImage: String = "bowl-"
    var limitOffalls: Int = 3
    var fallElementsList: [String] = []
    var fallElementsListSave: [String] = []
    var fallElementsCatched: [String] = []
    var fallElementTimer = Timer()
    var speedElement: Double = 3
    var resultElements: [EndGameModel] = []
    
    @Published var gameOver: Bool = false
    
    struct CBItmask {
        static let playerBowl: UInt32 = 0b10
        static let endLine: UInt32 = 0b100
        static let fallElment: UInt32 = 0b1000
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let level = UserDefaults.getLevel()
        self.configureBaseElements(level: level)
        
        backgroundImage = .init(imageNamed: "Background-\(self.randomInt)")
        scene?.size = CGSize(width: 750, height: 1335)
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.setScale(1.2)
        backgroundImage.zPosition = 1
        addChild(backgroundImage)
        

        createBowl()
        createFinalLine()
        
        fallElementTimer = .scheduledTimer(timeInterval: repeatFall, target: self, selector: #selector(fallElements), userInfo: nil, repeats: true)
    }
    
    private func configureBaseElements(level: levels) {
        self.gameLevel = level
        
        
        if level == .easy || level == .none {
            bowlImage += "1"
            numbersOfFall = 15
            repeatFall = 1.5
            limitOffalls = 3
            speedElement = 3
        } else if level ==  .medium {
            bowlImage += "2"
            numbersOfFall = 25
            repeatFall = 1.5
            limitOffalls = 5
            speedElement = 2
        } else {
            bowlImage += "3"
            numbersOfFall = 35
            repeatFall = 1
            limitOffalls = 7
            speedElement = 2
        }
        
        let listElements = (1...limitOffalls).randomElements(numbersOfFall)
        self.fallElementsList = listElements.map {String($0)}
        self.fallElementsListSave = fallElementsList
    }
    
    
    func createBowl() {
        playerBowl = .init(imageNamed: self.bowlImage)
        playerBowl.position = CGPoint(x: size.width / 2, y: 100)
        playerBowl.zPosition = 10
        playerBowl.setScale(0.16)
        playerPhysisc = .init(color: .clear, size: CGSize(width: playerBowl.size.width, height: 5))
        playerPhysisc.setScale(0.6)
        playerPhysisc.position = CGPoint(x: size.width / 2, y: 120)
        playerPhysisc.zPosition = 12
        
        
        
        playerPhysisc.physicsBody = SKPhysicsBody(rectangleOf: playerPhysisc.size)
        playerPhysisc.physicsBody?.affectedByGravity = false
        playerPhysisc.physicsBody?.isDynamic = false
        playerPhysisc.physicsBody?.categoryBitMask = CBItmask.playerBowl
        playerPhysisc.physicsBody?.contactTestBitMask = CBItmask.fallElment
        playerPhysisc.physicsBody?.collisionBitMask = CBItmask.fallElment
        addChild(playerBowl)
        addChild(playerPhysisc)
    }
    
    func createFinalLine() {
        endLine = .init(color: .clear, size: CGSize(width: size.width, height: 10))
        endLine.position = CGPoint(x: size.width / 2, y: 10)
        endLine.zPosition = 20
        
        endLine.physicsBody = SKPhysicsBody(rectangleOf: endLine.size)
        endLine.physicsBody?.affectedByGravity = false
        endLine.physicsBody?.isDynamic = false
        endLine.physicsBody?.categoryBitMask = CBItmask.endLine
        endLine.physicsBody?.contactTestBitMask = CBItmask.fallElment
        endLine.physicsBody?.collisionBitMask = CBItmask.fallElment
        addChild(endLine)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            playerBowl.position.x = location.x
            playerPhysisc.position.x = location.x
        }
    }
    
    @objc func fallElements() {
        let randomPosition = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        
        if !fallElementsList.isEmpty {
            let type = fallElementsList.removeFirst()
            fallElement = .init(imageNamed: ("game_" + type))
            fallElement.position = CGPoint(x: randomPosition.nextInt(), y: 1390)
            fallElement.zPosition = 5
            fallElement.setScale(1)
            fallElement.name = ("game_" + type)
            
            fallElement.physicsBody = SKPhysicsBody(rectangleOf: fallElement.size)
            fallElement.physicsBody?.affectedByGravity = true
            fallElement.physicsBody?.isDynamic = true
            fallElement.physicsBody?.categoryBitMask = CBItmask.fallElment
            fallElement.physicsBody?.contactTestBitMask = CBItmask.playerBowl
            fallElement.physicsBody?.collisionBitMask = CBItmask.playerBowl
            addChild(fallElement)
            
            let moveAction = SKAction.moveTo(y: -100, duration: speedElement)
            let deleteAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction, deleteAction])
            
            fallElement.run(combine)
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA : SKPhysicsBody
        let contactB : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }

    
        if contactA.categoryBitMask == CBItmask.playerBowl && contactB.categoryBitMask == CBItmask.fallElment {
            catchEelement(element: contactB.node as! SKSpriteNode, succes: true)
        } else if contactA.categoryBitMask == CBItmask.endLine && contactB.categoryBitMask == CBItmask.fallElment {
            catchEelement(element: contactB.node as! SKSpriteNode, succes: false)
        }
    }
    
    private func catchEelement(element: SKSpriteNode, succes: Bool) {
        element.removeFromParent()
        
        if succes {
            fallElementsCatched.append(element.name?.last?.description ?? "")
        }
        
        countFall += 1
        if countFall == numbersOfFall {
            convertResultsToModel()
            gameOver.toggle()
        }
        
    }
    
    private func convertResultsToModel() {
        for limit in (1...limitOffalls) {
            let index = String(limit)
            let realResult = self.fallElementsCatched.filter{ $0 == index}.count
            let totalElement = self.fallElementsListSave.filter{ $0 == index}.count
            if totalElement != 0 {
                let model = EndGameModel(index: limit, realResult: realResult, totalElements: totalElement, posibleResult: 0)
                resultElements.append(model)
            }
        }
    }
}
