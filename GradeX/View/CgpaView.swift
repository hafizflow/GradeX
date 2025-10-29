import SwiftUI

struct CgpaView: View {
    @State private var activeCard: UUID?
    @State private var showingAddUser = false
    @State private var showingAddSemester = false
    @Binding var activeCardId: UUID?
    @Binding var cards: [Card]
    @Environment(\.colorScheme) private var scheme
    @State private var semesterName: String = ""
    
    private var activeCardData: Card? {
        cards.first { $0.id == activeCard }
    }
    
    private var activeSemesters: [Semester] {
        activeCardData?.semesters ?? []
    }
    
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
                                        
                                            // Cards count indicator
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
                            
                                // Semesters and Courses List
                            LazyVStack(spacing: 15) {
                                if activeSemesters.isEmpty {
                                    VStack(spacing: 16) {
                                        Text("No semesters added yet")
                                            .font(.body)
                                            .foregroundStyle(.gray)
                                        
                                        Text("Tap the book icon below to add your first semester")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.top, 40)
                                    .padding(.horizontal, 30)
                                } else {
                                    ForEach(activeSemesters) { semester in
                                        SemesterSectionView(
                                            semester: semester,
                                            cardId: activeCard ?? UUID()
                                        ) { semesterId, course in
                                            addCourseToSemester(semesterId: semesterId, course: course)
                                        } onDeleteCourse: { semesterId, courseId in
                                            deleteCourse(semesterId: semesterId, courseId: courseId)
                                        }
                                    }
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
                        }
                    }
                    .onChange(of: activeCard) { oldValue, newValue in
                        activeCardId = newValue
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
            
            
                // Add Semester Button (bottom-right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if !cards.isEmpty {
                        if #available(iOS 26.0, *) {
                            Button(action: {
                                semesterName = ""
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
                                semesterName = ""
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
            VStack(spacing: 20) {
                CustomTextField(
                    title: "Add Semester",
                    text: $semesterName,
                    placeholder: "e.g., Spring 2024",
                    autoFocus: true
                )
                .padding(.horizontal, 24)
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        showingAddSemester = false
                        semesterName = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    
                    Button("Add") {
                        addSemester()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(semesterName.isEmpty ? Color.gray.opacity(0.2) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(semesterName.isEmpty)
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
            .presentationDetents([.height(200)])
        }
    }
    
    private func addSemester() {
        guard !semesterName.isEmpty,
              let cardIndex = cards.firstIndex(where: { $0.id == activeCard }) else { return }
        
        let newSemester = Semester(name: semesterName)
        cards[cardIndex].semesters.append(newSemester)
        semesterName = ""
        showingAddSemester = false
    }
    
    private func addCourseToSemester(semesterId: UUID, course: Course) {
        guard let cardIndex = cards.firstIndex(where: { $0.id == activeCard }),
              let semesterIndex = cards[cardIndex].semesters.firstIndex(where: { $0.id == semesterId }) else { return }
        
        cards[cardIndex].semesters[semesterIndex].courses.append(course)
    }
    
    private func deleteCourse(semesterId: UUID, courseId: UUID) {
        guard let cardIndex = cards.firstIndex(where: { $0.id == activeCard }),
              let semesterIndex = cards[cardIndex].semesters.firstIndex(where: { $0.id == semesterId }) else { return }
        
        cards[cardIndex].semesters[semesterIndex].courses.removeAll { $0.id == courseId }
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
        Card(bgColor: .blue, studentName: "Preview")
    ]))
}
