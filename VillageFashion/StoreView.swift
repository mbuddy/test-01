import SwiftUI

struct StoreView: View {
    @Environment(GameState.self) private var gameState
    @Environment(\.dismiss) private var dismiss
    let store: Store

    @State private var showingPurchaseSuccess = false
    @State private var showingInsufficientFunds = false
    @State private var showingAlreadyOwned = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Store Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(store.color.opacity(0.2))
                                .frame(width: 100, height: 100)

                            Text(store.emoji)
                                .font(.system(size: 50))
                        }

                        Text(store.name)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Specializing in \(store.specialty.rawValue)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()

                    // Customer Info
                    if let creature = gameState.selectedCreature {
                        HStack {
                            CreatureView(creature: creature, size: 50)

                            VStack(alignment: .leading) {
                                Text(creature.name)
                                    .font(.headline)
                                HStack {
                                    Text("💰")
                                    Text("\(creature.coins) coins")
                                        .fontWeight(.semibold)
                                }
                                .font(.subheadline)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                    }

                    // Items for Sale
                    LazyVStack(spacing: 16) {
                        ForEach(store.items) { item in
                            ItemCard(item: item, store: store)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Purchase Successful!", isPresented: $showingPurchaseSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Enjoy your new item! Check your wardrobe to wear it.")
            }
            .alert("Not Enough Coins", isPresented: $showingInsufficientFunds) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You need more coins to buy this item.")
            }
            .alert("Already Owned", isPresented: $showingAlreadyOwned) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You already own this item!")
            }
        }
    }
}

struct ItemCard: View {
    @Environment(GameState.self) private var gameState
    let item: FashionItem
    let store: Store

    @State private var showingPurchaseSuccess = false
    @State private var showingInsufficientFunds = false
    @State private var showingAlreadyOwned = false

    var isOwned: Bool {
        guard let creature = gameState.selectedCreature else { return false }
        return gameState.isItemOwned(item, by: creature)
    }

    var canAfford: Bool {
        guard let creature = gameState.selectedCreature else { return false }
        return creature.coins >= item.price
    }

    var body: some View {
        HStack(spacing: 16) {
            // Item Preview
            Text(item.emoji)
                .font(.system(size: 50))
                .frame(width: 70, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(store.color.opacity(0.1))
                )

            // Item Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)

                HStack {
                    Text("💰 \(item.price)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(canAfford ? .primary : .red)
                }
            }

            Spacer()

            // Purchase Button
            if isOwned {
                Text("Owned ✓")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.2))
                    )
            } else {
                Button(action: purchase) {
                    Text("Buy")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(canAfford ? store.color : Color.gray)
                        )
                }
                .disabled(!canAfford)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.1), radius: 4, y: 2)
        )
        .alert("Purchase Successful!", isPresented: $showingPurchaseSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Enjoy your new \(item.name)! Check your wardrobe to wear it.")
        }
        .alert("Not Enough Coins", isPresented: $showingInsufficientFunds) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You need \(item.price - (gameState.selectedCreature?.coins ?? 0)) more coins.")
        }
        .alert("Already Owned", isPresented: $showingAlreadyOwned) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You already own this item!")
        }
    }

    private func purchase() {
        let success = gameState.purchaseItem(item)

        if success {
            showingPurchaseSuccess = true
        } else if isOwned {
            showingAlreadyOwned = true
        } else {
            showingInsufficientFunds = true
        }
    }
}

#Preview {
    StoreView(store: Store.hatShop)
        .environment(GameState())
}
