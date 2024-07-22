import Foundation
import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        // Do nothing
    }
}

struct FeedPosition: Equatable {
    var scrollViewOffset: CGFloat
    var sectionGlobalIndex: Int
    var itemGlobalIndex: Int
    var itemRelativeIndex: Int
}

struct ScrollOffsetFeedView: View {
    
    static func createLocalSections() -> [Section] {
        return [Section(id: "1", color: .green, items: ["1", "2", "3", "4"]),
                Section(id: "2", color: .red, items: ["1", "2", "3"]),
                Section(id: "3", color: .blue, items: ["1", "2", "3", "4", "5"])]
    }
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var feedPosition: FeedPosition?
    @State private var sections: [Section]
    @State private var lastSeenSectionIndex = 0
    @State private var lastCompletedItemIndex: Int?
    
    init(sections: [Section]) {
        self.sections = sections
    }
    
    var body: some View {
        ScrollViewReader { proxy in
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
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: geometry.frame(in: .named("scroll")).origin)
                        })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                    }
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
            .onChange(of: scrollPosition) { oldValue, newValue in
                let sectionHeights = calculateSectionsHeights(sections: sections)
                let newFeedPosition = calculateFeedtPosition(scrollPositionY: -1 * newValue.y,
                                                             sectionHeights: sectionHeights)
                // TODO: check if oldValue is bigger than newValue and if the potential index is not correct, force to scroll to the first item
                if newFeedPosition.sectionGlobalIndex < lastSeenSectionIndex
                    && newValue.y > oldValue.y {
                    // TODO: Force scroll to needed position
                    print("Force to scroll back to the new section: \(lastSeenSectionIndex)")
                    let lastSeenSectionId = sections[lastSeenSectionIndex].id
                    proxy.scrollTo(lastSeenSectionId, anchor: .top)
                }
                else {
                    feedPosition = newFeedPosition
                }

            }
            .onChange(of: feedPosition?.sectionGlobalIndex) { oldValue, newValue in
                if let oldValue = oldValue {
                    customSectionOnDisappear(index: oldValue)
                }
                if let newValue = newValue {
                    customSectionOnAppear(index: newValue)
                }
            }
            .onChange(of: feedPosition?.itemRelativeIndex) { oldValue, newValue in
                if let oldValue = oldValue {
                    customItemOnDisappear(sectionIndex: 0, itemIndex: oldValue)
                }
                if let newValue = newValue {
                    customItemOnAppear(sectionIndex: 0, itemIndex: newValue)
                }
            }
        }
    }
    
    @ViewBuilder func makeSectionsCounter() -> some View {
        ZStack {
            if let feedPosition = feedPosition {
                Text("Sections completed \(feedPosition.sectionGlobalIndex), item \(feedPosition.itemRelativeIndex + 1) / \(sections[feedPosition.sectionGlobalIndex].items.count)")
            }
        }
        .padding()
    }
    
    private func calculateSectionsHeights(sections: [Section]) -> [CGFloat] {
        let screenHeight = UIScreen.main.bounds.height
        return sections.map { section in
            return screenHeight * CGFloat(section.items.count)
        }
    }
    
    private func calculateFeedtPosition(scrollPositionY: CGFloat,
                                        sectionHeights: [CGFloat]) -> FeedPosition {
        var itemIndex = 0
        var currentCumulativeSectionsHeight = 0.0
        let oneScreenHeight = UIScreen.main.bounds.height
        for sectionHeight in sectionHeights {
            if currentCumulativeSectionsHeight + sectionHeight > scrollPositionY {
                break
            }
            itemIndex += 1
            currentCumulativeSectionsHeight += sectionHeight
        }
        let visibleFeedSubItemGlobalIndex = Int(scrollPositionY) / Int(oneScreenHeight)
        let visibleFeedSubItemReletiveIndex = Int(scrollPositionY - currentCumulativeSectionsHeight) / Int(oneScreenHeight)
        
        return FeedPosition(scrollViewOffset: scrollPositionY,
                            sectionGlobalIndex: itemIndex,
                            itemGlobalIndex: visibleFeedSubItemGlobalIndex,
                            itemRelativeIndex: visibleFeedSubItemReletiveIndex)
    }
    
    private func customSectionOnAppear(index: Int) {
        print("Custom Section Appear: \(index)")
        if index > lastSeenSectionIndex {
            lastSeenSectionIndex = index
        }
    }
    
    private func customSectionOnDisappear(index: Int) {
        print("Custom Section Disappear: \(index)")
    }
    
    private func customItemOnAppear(sectionIndex: Int, itemIndex: Int) {
        print("Custom Item Appear: section \(sectionIndex) item \(itemIndex)")
    }
    
    private func customItemOnDisappear(sectionIndex: Int, itemIndex: Int) {
        print("Custom Item Disappear: section \(sectionIndex) item \(itemIndex)")
    }
    
}


#Preview {
    ScrollOffsetFeedView(sections: ScrollOffsetFeedView.createLocalSections())
}
