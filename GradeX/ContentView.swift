import SwiftUI

struct ContentView: View {
    @State private var activeCardId: UUID?
    @State private var cards: [Card] = []
    
    var activeCardColor: Color {
        guard let activeCardId = activeCardId,
              let activeCard = cards.first(where: { $0.id == activeCardId }) else {
            return cards.first?.bgColor ?? .blue
        }
        return activeCard.bgColor
    }
    
    var body: some View {
        TabView {
            CgpaView(activeCardId: $activeCardId, cards: $cards)
                .tabItem { Label("CGPA", systemImage: "square.and.pencil") }
            Text("Statistics").tabItem { Label("Statistics", systemImage: "waveform.path.ecg") }
            Text("Settings").tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(activeCardColor)
    }
}

#Preview {
    ContentView()
}
