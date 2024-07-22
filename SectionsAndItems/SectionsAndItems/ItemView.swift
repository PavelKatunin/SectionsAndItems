import Foundation
import SwiftUI

struct ItemView: View {
    
    @State private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        ZStack {
            Text("\(text)").font(.title)
        }
        .onAppear() {
            // print("SiwftUI event: Item \(text) appeared")
        }
        .onDisappear() {
            // print("SiwftUI event: Item \(text) disappeared")
        }
    }
    
}


#Preview {
    ItemView(text: "1")
}
