import SwiftUI

func createSections() -> [Section] {
    return [Section(id: "1", color: .green, items: ["1", "2", "3", "4"]),
            Section(id: "2", color: .red, items: ["1", "2", "3"]),
            Section(id: "3", color: .blue, items: ["1", "2", "3", "4", "5"]),
            Section(id: "4", color: .green, items: ["1", "2", "3", "4"]),
            Section(id: "5", color: .red, items: ["1", "2", "3"]),
            Section(id: "6", color: .blue, items: ["1", "2", "3", "4", "5"])]
}

struct ContentView: View {
    
    var body: some View {
        ScrollOffsetFeedView(sections: createSections())
    }

}

#Preview {
    ContentView()
}
