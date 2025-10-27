import SwiftUI

struct CgpaView: View {
    @State private var allCourses: [Course] = []
    @State private var activeCard: UUID?
    @Environment(\.colorScheme) private var scheme
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Welcome !!!")
                                .font(.title.bold())
                                .padding(.horizontal, 15)
                            
                            Text("To GradeX")
                                .font(.callout)
                                .padding(.horizontal, 15)
                        }
                        .frame(height: 45)
                        .padding(.bottom, 10)
                        
                        
                        GeometryReader {
                            let rect = $0.frame(in: .scrollView)
                            let minY = rect.minY.rounded()
                            
                                // Card View
                            ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                    ForEach(cards) { card in
                                        ZStack {
                                            if minY == 85.0 {
                                                    /// Not Scrolled
                                                    /// Showing All Cards
                                                CardView(card)
                                            } else  {
                                                    /// Scrolled
                                                    ///  Showing Only Selected Card
                                                if activeCard == card.id {
                                                    CardView(card)
                                                } else {
                                                    Rectangle().fill(.clear)
                                                    
                                                }
                                            }
                                        }
                                        .containerRelativeFrame(.horizontal)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollPosition(id: $activeCard)
                            .scrollTargetBehavior(.paging)
                            .scrollClipDisabled()
                            .scrollIndicators(.hidden)
                            .scrollDisabled(minY != 85.0)
                        }
                        .frame(height: 125)
                    }
                    
                    LazyVStack(spacing: 15) {
                        ForEach(allCourses) { course in
                            CourseGradeCardView(course)
                        }
                    }
                    .padding(15)
                    .mask {
                        Rectangle()
                            .visualEffect { content, proxy in
                                content.offset(y: backgroundLimitOffset(proxy))
                            }
                    }
                    .background {
                        GeometryReader {
                            let rect = $0.frame(in: .scrollView)
                            let minY = min(rect.minY - 125, 0)
                            let progress = max(min(-minY / 25, 1), 0)
                            
                            RoundedRectangle(cornerRadius: 20 * progress, style: .continuous)
                                .fill(scheme == .dark ? .black : .white)
                                .overlay(alignment: .top) {
                                    
                                }
                                .visualEffect { content, proxy in
                                    content
                                        .offset(y: backgroundLimitOffset(proxy))
                                }
                        }
                    }
                }
                .padding(.vertical, 15)
            }
            .scrollTargetBehavior(CustomScrollBehaviour())
            .scrollIndicators(.hidden)
            .onAppear {
                if activeCard == nil {
                    activeCard = cards.first?.id
                    allCourses = courses.shuffled()
                }
            }
            .onChange(of: activeCard) { oldValue, newValue in
                withAnimation(.snappy) {
                    allCourses = courses.shuffled()
                }
            }
            if #available(iOS 26.0, *) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .font(.body.bold())
                })
                .buttonStyle(.glass)
                .padding()
                .padding(.top, 8)
                .padding(.trailing, 8)
                .contentShape(Rectangle())
            } else {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .font(.body.bold())
                })
                .buttonStyle(.borderedProminent)
                .padding()
                .padding(.top, 8)
                .padding(.trailing, 8)
                .contentShape(Rectangle())
            }
            
        }
    }
    
    /// Background Limit Offset
    nonisolated func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 90 ? -minY + 90 : 0
    }
    
        /// Card View
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = 85.0
            
            let offset = min(minY - topValue, 0)
            let progress = max(min(-offset / topValue, 1),0)
            let scale = 1 + progress
            
            ZStack {
                Rectangle()
                    .fill(card.bgColor)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(card.bgColor)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.15))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: 170, y: 40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .scaleEffect(scale, anchor: .bottom)
                
                VStack(alignment: .leading, spacing: 4 - (progress * 8)) {
                    Spacer(minLength: 0)
                    
                    Text("\(card.studentName)")
                        .font(.title3.bold())
                        .scaleEffect(1 - (progress * 0.15), anchor: .leading)
                    
                    Text("CGPA: \(String(format: "%.2f", card.cgpa))")
                        .font(.title.bold())
                        .scaleEffect(1 - (progress * 0.2), anchor: .leading)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .offset(y: progress * -35)
            }
            .offset(y: -offset)
            .offset(y: progress * -topValue)
        }
        .padding(.horizontal, 15)
    }
    
    
        /// Course Grade Card View
    @ViewBuilder
    func CourseGradeCardView(_ course: Course) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(course.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("Credit: \(String(format: "%.1f", course.credit))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
            })
            
            Spacer(minLength: 0)
            
            Text(String(format: "%.2f", course.gpa))
                .font(.body)
                .foregroundStyle(.gray)
            
        }
        .lineLimit(1)
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
}

struct CustomScrollBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 85 {
            target.rect = .zero
        }
    }
}

#Preview {
    CgpaView()
}
 
