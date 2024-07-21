import Foundation
import SwiftUI


struct ScrollOffsetFeedView: View {
    
    static func createLocalSections() -> [Section] {
        return [Section(id: "1", color: .green, items: ["1", "2", "3", "4"]),
                Section(id: "2", color: .red, items: ["1", "2", "3"]),
                Section(id: "3", color: .blue, items: ["1", "2", "3", "4", "5"])]
    }
    
    @State var sections: [Section]
    
    init(sections: [Section]) {
        self.sections = sections
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sections, id: \.id) { section in
                        SectionView(color: section.color,
                                    items: section.items,
                                    sectionId: section.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            VStack {
                ZStack {
                    makeSectionsCounter()
                        .background(Color(white: 0.0, opacity: 0.5))
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder func makeSectionsCounter() -> some View {
        ZStack {
            Text("Sections completed 0, item 1 / 4")
        }
        .padding()
    }
    
}


#Preview {
    ScrollOffsetFeedView(sections: ScrollOffsetFeedView.createLocalSections())
}
