import Foundation
import SwiftUI

struct SectionView: View {
    
    @State private var color: Color
    @State private var items: [String]
    private var sectionId: String
    
    init(color: Color, items: [String], sectionId: String) {
        self.color = color
        self.items = items
        self.sectionId = sectionId
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items, id: \.hashValue) { item in
                ItemView(text: item)
                    .frame(height: UIScreen.main.bounds.size.height)
            }
        }
        .onAppear() {
            // print("SiwftUI event: Section \(sectionId) appeared")
        }
        .onDisappear() {
            // print("SiwftUI event: Section \(sectionId) disappeared")
        }
        .background(color)
    }
    
}


#Preview {
    SectionView(color: .green, 
                items: ["1", "2", "3", "4"],
                sectionId: "1")
}
