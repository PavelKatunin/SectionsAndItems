import Foundation
import SwiftUI

struct ItemView: View {
    
    @State var text: String
    
    var body: some View {
        ZStack {
            Text("\(text)").font(.title)
        }
        .onAppear() {
            print("SiwftUI event: Item \(text) appeared")
        }
        .onDisappear() {
            print("SiwftUI event: Item \(text) disappeared")
        }
    }
    
}


#Preview {
    ItemView(text: "1")
}
