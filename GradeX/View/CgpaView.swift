import SwiftUI

struct CgpaView: View {
    @State private var allCourses: [Course] = []
    @State private var activeCard: UUID?
    @State private var showingAddUser = false
    @State private var showingAddSemester = false
    @Binding var activeCardId: UUID?
    @Binding var cards: [Card]
    @Environment(\.colorScheme) private var scheme
    @State private var semester: String = ""
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if cards.isEmpty {
                    // Empty State
                VStack(spacing: 0) {
                        // Header Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Welcome !!!")
                            .font(.title.bold())
                            .padding(.horizontal, 15)
                        
                        Text("To GradeX")
                            .font(.callout)
                            .padding(.horizontal, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 45)
                    .padding(.bottom, 10)
                    .padding(.top, 15)
                    
                    Spacer()
                    
                        // Empty State Message
                    Text("Add user to calculate CGPA")
                        .font(.body)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                }
            } else {
                NavigationStack {
                        // Normal View with Cards
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 15) {
                                
                                    // Header Section
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
                                    let topValue: CGFloat = 85.0
                                    let offset = min(minY - topValue, 0)
                                    let progress = max(min(-offset / topValue, 1), 0)
                                    
                                    VStack(spacing: 0) {
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
                                        
                                            // Cards count indicator - now below the cards
                                        if cards.count > 1 {
                                            HStack(spacing: 6) {
                                                ForEach(cards) { card in
                                                    Circle()
                                                        .fill(activeCard == card.id ? Color.primary : Color.primary.opacity(0.3))
                                                        .frame(width: 6, height: 6)
                                                        .animation(.easeInOut(duration: 0.3), value: activeCard)
                                                }
                                            }
                                            .padding(.top, 12)
                                            .opacity(1 - progress)
                                        }
                                    }
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
                            activeCardId = cards.first?.id
                            allCourses = courses.shuffled()
                        }
                    }
                    .onChange(of: activeCard) { oldValue, newValue in
                        withAnimation(.snappy) {
                            allCourses = courses.shuffled()
                            activeCardId = newValue
                        }
                    }
                }
            }
            
                // Floating Action Buttons
            VStack(spacing: 12) {
                    // Add User Button
                if #available(iOS 26.0, *) {
                    Button(action: {
                        showingAddUser = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.body.bold())
                            .padding(6)
                    })
                    .buttonStyle(.glass)
                    .contentShape(Rectangle())
                } else {
                    Button(action: {
                        showingAddUser = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.body.bold())
                            .padding(6)
                    })
                    .buttonStyle(.borderedProminent)
                    .contentShape(Rectangle())
                }
            }
            .padding()
            .padding(.top, 0)
            .padding(.trailing, 8)
            
            
                // ✅ Add Semester Button (bottom-right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if !cards.isEmpty {
                        if #available(iOS 26.0, *) {
                            Button(action: {
                                showingAddSemester = true
                            }, label: {
                                Image(systemName: "book")
                                    .font(.title2.bold())
                                    .padding(8)
                            })
                            .buttonStyle(.glass)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                        } else {
                            Button(action: {
                                showingAddSemester = true
                            }, label: {
                                Image(systemName: "book")
                                    .font(.title2.bold())
                                    .padding(8)
                            })
                            .buttonStyle(.borderedProminent)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                        }
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 25)
            }
            
        }
        .fullScreenCover(isPresented: $showingAddUser) {
            AddUserView { newCard in
                cards.append(newCard)
                activeCard = newCard.id
                activeCardId = newCard.id
            }
        }
        .sheet(isPresented: $showingAddSemester) {
             CustomTextField(title: "Add Semester", text: $semester, placeholder: "Enter Semester Name", autoFocus: true)
                .padding(.horizontal, 24)
                .presentationDetents([.fraction(0.17)])
                
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
    CgpaView(activeCardId: .constant(nil), cards: .constant([
        Card(bgColor: .blue, studentName: "Preview", cgpa: 3.80)
    ]))
}
