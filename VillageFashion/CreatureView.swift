import SwiftUI

struct CreatureView: View {
    let creature: Creature
    var size: CGFloat = 100

    var body: some View {
        ZStack {
            // Creature body
            Text(creature.type.rawValue)
                .font(.system(size: size))

            // Equipped items overlay
            VStack(spacing: 0) {
                // Hat
                if let hat = creature.wardrobe.currentHat {
                    Text(hat.emoji)
                        .font(.system(size: size * 0.4))
                        .offset(y: -size * 0.3)
                }

                Spacer()

                // Accessory
                if let accessory = creature.wardrobe.currentAccessory {
                    Text(accessory.emoji)
                        .font(.system(size: size * 0.3))
                        .offset(x: size * 0.35, y: size * 0.1)
                }
            }
            .frame(height: size)
        }
        .frame(width: size, height: size)
    }
}

struct CreatureCard: View {
    let creature: Creature
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                CreatureView(creature: creature, size: 80)

                Text(creature.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Text("💰")
                    Text("\(creature.coins)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.secondary)
            }
            .padding()
            .frame(width: 140, height: 160)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color(.systemBackground))
                    .shadow(color: isSelected ? .blue : .gray.opacity(0.3), radius: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

struct WardrobeView: View {
    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                if let creature = gameState.selectedCreature {
                    VStack(spacing: 24) {
                        // Preview
                        VStack(spacing: 12) {
                            Text("Current Look")
                                .font(.title2)
                                .fontWeight(.bold)

                            CreatureView(creature: creature, size: 150)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(.systemGray6))
                                )
                        }
                        .padding()

                        // Wardrobe sections
                        WardrobeSection(
                            title: "Hats",
                            items: creature.wardrobe.hats,
                            currentItem: creature.wardrobe.currentHat
                        )

                        WardrobeSection(
                            title: "Accessories",
                            items: creature.wardrobe.accessories,
                            currentItem: creature.wardrobe.currentAccessory
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct WardrobeSection: View {
    @Environment(GameState.self) private var gameState
    let title: String
    let items: [FashionItem]
    let currentItem: FashionItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            if items.isEmpty {
                Text("No items yet. Visit stores to shop!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // None option
                        Button(action: {
                            equipNone()
                        }) {
                            VStack {
                                Text("✖️")
                                    .font(.system(size: 40))
                                Text("None")
                                    .font(.caption2)
                            }
                            .frame(width: 80, height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(currentItem == nil ? Color.blue.opacity(0.2) : Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(currentItem == nil ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)

                        ForEach(items) { item in
                            Button(action: {
                                gameState.equipItem(item)
                            }) {
                                VStack {
                                    Text(item.emoji)
                                        .font(.system(size: 40))
                                    Text(item.name)
                                        .font(.caption2)
                                        .lineLimit(1)
                                }
                                .frame(width: 80, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(currentItem?.id == item.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(currentItem?.id == item.id ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func equipNone() {
        guard var creature = gameState.selectedCreature else { return }

        // Unequip based on section
        if title == "Hats" {
            creature.wardrobe.currentHat = nil
        } else if title == "Accessories" {
            creature.wardrobe.currentAccessory = nil
        }

        if let index = gameState.creatures.firstIndex(where: { $0.id == creature.id }) {
            gameState.creatures[index] = creature
            gameState.selectedCreature = creature
        }
    }
}
