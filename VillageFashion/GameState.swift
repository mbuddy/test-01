import Foundation
import SwiftUI

@Observable
class GameState {
    var creatures: [Creature] = []
    var selectedCreature: Creature?
    var stores: [Store] = Store.allStores
    var currentStore: Store?
    var showingStore = false
    var showingWardrobe = false

    init() {
        // Create some starter creatures
        creatures = [
            Creature(name: "Bella", type: .bunny, coins: 150),
            Creature(name: "Whiskers", type: .cat, coins: 200),
            Creature(name: "Fluffy", type: .fox, coins: 120)
        ]
        selectedCreature = creatures.first
    }

    func purchaseItem(_ item: FashionItem) -> Bool {
        guard var creature = selectedCreature else { return false }
        guard creature.coins >= item.price else { return false }

        // Check if already owned
        let alreadyOwned = isItemOwned(item, by: creature)
        if alreadyOwned {
            return false
        }

        creature.coins -= item.price
        creature.wardrobe.addItem(item)

        // Update the creature in the array
        if let index = creatures.firstIndex(where: { $0.id == creature.id }) {
            creatures[index] = creature
            selectedCreature = creature
        }

        return true
    }

    func isItemOwned(_ item: FashionItem, by creature: Creature) -> Bool {
        switch item.category {
        case .hat:
            return creature.wardrobe.hats.contains(where: { $0.id == item.id })
        case .top:
            return creature.wardrobe.tops.contains(where: { $0.id == item.id })
        case .bottom:
            return creature.wardrobe.bottoms.contains(where: { $0.id == item.id })
        case .shoes:
            return creature.wardrobe.shoes.contains(where: { $0.id == item.id })
        case .accessory:
            return creature.wardrobe.accessories.contains(where: { $0.id == item.id })
        }
    }

    func equipItem(_ item: FashionItem) {
        guard var creature = selectedCreature else { return }
        creature.wardrobe.equipItem(item)

        if let index = creatures.firstIndex(where: { $0.id == creature.id }) {
            creatures[index] = creature
            selectedCreature = creature
        }
    }

    func openStore(_ store: Store) {
        currentStore = store
        showingStore = true
    }

    func closeStore() {
        showingStore = false
        currentStore = nil
    }

    func selectCreature(_ creature: Creature) {
        selectedCreature = creature
    }

    func addCoins(_ amount: Int) {
        guard var creature = selectedCreature else { return }
        creature.coins += amount

        if let index = creatures.firstIndex(where: { $0.id == creature.id }) {
            creatures[index] = creature
            selectedCreature = creature
        }
    }
}
