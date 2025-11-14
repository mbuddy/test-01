import SwiftUI

struct ContentView: View {
    @Environment(GameState.self) private var gameState

    var body: some View {
        @Bindable var bindableGameState = gameState

        TabView {
            // Village Tab
            VillageView()
                .tabItem {
                    Label("Village", systemImage: "house.fill")
                }

            // Creatures Tab
            CreaturesListView()
                .tabItem {
                    Label("Creatures", systemImage: "pawprint.fill")
                }
        }
        .sheet(isPresented: $bindableGameState.showingStore) {
            if let store = gameState.currentStore {
                StoreView(store: store)
            }
        }
        .sheet(isPresented: $bindableGameState.showingWardrobe) {
            WardrobeView()
        }
    }
}

struct CreaturesListView: View {
    @Environment(GameState.self) private var gameState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Your Creatures")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Select a creature to shop with")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    // Creatures Grid
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 140), spacing: 16)
                    ], spacing: 16) {
                        ForEach(gameState.creatures) { creature in
                            CreatureCard(
                                creature: creature,
                                isSelected: gameState.selectedCreature?.id == creature.id,
                                action: {
                                    gameState.selectCreature(creature)
                                }
                            )
                        }
                    }
                    .padding()

                    // Selected Creature Details
                    if let selected = gameState.selectedCreature {
                        VStack(spacing: 16) {
                            Divider()

                            Text("Selected: \(selected.name)")
                                .font(.title2)
                                .fontWeight(.semibold)

                            CreatureView(creature: selected, size: 120)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(.systemGray6))
                                )

                            HStack(spacing: 20) {
                                // Wardrobe Button
                                Button(action: {
                                    gameState.showingWardrobe = true
                                }) {
                                    Label("Wardrobe", systemImage: "tshirt.fill")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.purple)
                                        )
                                }

                                // Add Coins Button
                                Button(action: {
                                    gameState.addCoins(50)
                                }) {
                                    Label("Add 💰50", systemImage: "plus.circle.fill")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.green)
                                        )
                                }
                            }
                            .padding(.horizontal)

                            // Stats
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("💰 Coins:")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(selected.coins)")
                                }

                                HStack {
                                    Text("🎩 Hats Owned:")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(selected.wardrobe.hats.count)")
                                }

                                HStack {
                                    Text("✨ Accessories:")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(selected.wardrobe.accessories.count)")
                                }

                                HStack {
                                    Text("👕 Total Items:")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    let total = selected.wardrobe.hats.count +
                                               selected.wardrobe.tops.count +
                                               selected.wardrobe.bottoms.count +
                                               selected.wardrobe.shoes.count +
                                               selected.wardrobe.accessories.count
                                    Text("\(total)")
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
        .environment(GameState())
}
