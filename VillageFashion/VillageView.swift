import SwiftUI

struct VillageView: View {
    @Environment(GameState.self) private var gameState

    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("🏘️ Fashion Village")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if let creature = gameState.selectedCreature {
                        HStack {
                            Text("Shopping as \(creature.name)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text("💰 \(creature.coins) coins")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.yellow.opacity(0.3))
                                )
                        }
                    }
                }
                .padding(.top)

                // Stores Grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(gameState.stores) { store in
                        StoreCard(store: store)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct StoreCard: View {
    @Environment(GameState.self) private var gameState
    let store: Store

    var body: some View {
        Button(action: {
            gameState.openStore(store)
        }) {
            VStack(spacing: 12) {
                // Store Icon
                ZStack {
                    Circle()
                        .fill(store.color.opacity(0.2))
                        .frame(width: 80, height: 80)

                    Text(store.emoji)
                        .font(.system(size: 40))
                }

                // Store Info
                VStack(spacing: 4) {
                    Text(store.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(store.specialty.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.2), radius: 8, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VillageView()
        .environment(GameState())
}
