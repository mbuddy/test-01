import Foundation
import SwiftUI

// MARK: - Creature
struct Creature: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: CreatureType
    var coins: Int
    var wardrobe: Wardrobe

    init(id: UUID = UUID(), name: String, type: CreatureType, coins: Int = 100) {
        self.id = id
        self.name = name
        self.type = type
        self.coins = coins
        self.wardrobe = Wardrobe()
    }
}

enum CreatureType: String, Codable, CaseIterable {
    case bunny = "🐰"
    case cat = "🐱"
    case fox = "🦊"
    case bear = "🐻"
    case panda = "🐼"
    case koala = "🐨"
    case hamster = "🐹"
    case mouse = "🐭"

    var name: String {
        switch self {
        case .bunny: return "Bunny"
        case .cat: return "Cat"
        case .fox: return "Fox"
        case .bear: return "Bear"
        case .panda: return "Panda"
        case .koala: return "Koala"
        case .hamster: return "Hamster"
        case .mouse: return "Mouse"
        }
    }
}

// MARK: - Wardrobe
struct Wardrobe: Codable {
    var hats: [FashionItem] = []
    var tops: [FashionItem] = []
    var bottoms: [FashionItem] = []
    var shoes: [FashionItem] = []
    var accessories: [FashionItem] = []

    var currentHat: FashionItem?
    var currentTop: FashionItem?
    var currentBottom: FashionItem?
    var currentShoes: FashionItem?
    var currentAccessory: FashionItem?

    mutating func addItem(_ item: FashionItem) {
        switch item.category {
        case .hat:
            hats.append(item)
        case .top:
            tops.append(item)
        case .bottom:
            bottoms.append(item)
        case .shoes:
            shoes.append(item)
        case .accessory:
            accessories.append(item)
        }
    }

    mutating func equipItem(_ item: FashionItem) {
        switch item.category {
        case .hat:
            currentHat = item
        case .top:
            currentTop = item
        case .bottom:
            currentBottom = item
        case .shoes:
            currentShoes = item
        case .accessory:
            currentAccessory = item
        }
    }
}

// MARK: - Fashion Item
struct FashionItem: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let category: FashionCategory
    let emoji: String
    let price: Int
    let color: String

    init(id: UUID = UUID(), name: String, category: FashionCategory, emoji: String, price: Int, color: String = "default") {
        self.id = id
        self.name = name
        self.category = category
        self.emoji = emoji
        self.price = price
        self.color = color
    }
}

enum FashionCategory: String, Codable, CaseIterable {
    case hat = "Hats"
    case top = "Tops"
    case bottom = "Bottoms"
    case shoes = "Shoes"
    case accessory = "Accessories"
}

// MARK: - Store
struct Store: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let specialty: FashionCategory
    let items: [FashionItem]
    let color: Color

    init(id: UUID = UUID(), name: String, emoji: String, specialty: FashionCategory, items: [FashionItem], color: Color) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.specialty = specialty
        self.items = items
        self.color = color
    }
}

// MARK: - Sample Data
extension Store {
    static let hatShop = Store(
        name: "Fancy Hats",
        emoji: "🎩",
        specialty: .hat,
        items: [
            FashionItem(name: "Top Hat", category: .hat, emoji: "🎩", price: 50),
            FashionItem(name: "Crown", category: .hat, emoji: "👑", price: 100),
            FashionItem(name: "Party Hat", category: .hat, emoji: "🎉", price: 30),
            FashionItem(name: "Beret", category: .hat, emoji: "🧢", price: 40),
            FashionItem(name: "Wizard Hat", category: .hat, emoji: "🧙", price: 75),
        ],
        color: .purple
    )

    static let clothingStore = Store(
        name: "Chic Boutique",
        emoji: "👔",
        specialty: .top,
        items: [
            FashionItem(name: "T-Shirt", category: .top, emoji: "👕", price: 25),
            FashionItem(name: "Dress", category: .top, emoji: "👗", price: 60),
            FashionItem(name: "Sweater", category: .top, emoji: "🧥", price: 45),
            FashionItem(name: "Tuxedo", category: .top, emoji: "🤵", price: 120),
            FashionItem(name: "Hoodie", category: .top, emoji: "🧥", price: 40),
        ],
        color: .pink
    )

    static let shoeStore = Store(
        name: "Sole Mates",
        emoji: "👟",
        specialty: .shoes,
        items: [
            FashionItem(name: "Sneakers", category: .shoes, emoji: "👟", price: 35),
            FashionItem(name: "Boots", category: .shoes, emoji: "👢", price: 55),
            FashionItem(name: "Sandals", category: .shoes, emoji: "👡", price: 20),
            FashionItem(name: "High Heels", category: .shoes, emoji: "👠", price: 65),
            FashionItem(name: "Slippers", category: .shoes, emoji: "🥿", price: 15),
        ],
        color: .blue
    )

    static let accessoryShop = Store(
        name: "Sparkle & Shine",
        emoji: "💎",
        specialty: .accessory,
        items: [
            FashionItem(name: "Sunglasses", category: .accessory, emoji: "🕶️", price: 30),
            FashionItem(name: "Necklace", category: .accessory, emoji: "📿", price: 45),
            FashionItem(name: "Backpack", category: .accessory, emoji: "🎒", price: 40),
            FashionItem(name: "Watch", category: .accessory, emoji: "⌚", price: 80),
            FashionItem(name: "Ring", category: .accessory, emoji: "💍", price: 90),
        ],
        color: .yellow
    )

    static let allStores = [hatShop, clothingStore, shoeStore, accessoryShop]
}
