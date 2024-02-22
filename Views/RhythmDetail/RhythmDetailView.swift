//
//  RhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftData
import SwiftUI

struct RhythmDetailView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAddTaskView = false
    @Bindable var currentRhythm: Rhythm
    @State private var isActive: Bool = false
    
    // @Query var tasks: [TaskItem]
    //
    // init(currentRhythm: Rhythm) {
    //     self.currentRhythm = currentRhythm
    //     let currentRhythmID = currentRhythm.persistentModelID
    //
    //     _tasks = Query(
    //         filter: #Predicate<TaskItem> { task in
    //             task.rhythm?.persistentModelID == currentRhythmID
    //         }, sort: \TaskItem.name, order: .reverse)
    // }
    
    private var estimatedEndTime: Date {
        Calendar.current.date(byAdding: .second, value: currentRhythm.totalSeconds, to: Date.now) ?? .now
    }
    
    @State private var showCellAnimation = false
    @State var animationDelay = 0.5

    @State private var suggestStart: Bool = false
    @Environment(\.dismiss) var dismiss
    
    let gradient =
        LinearGradient(colors: [.teal, .green], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()
            
            Color.black.opacity(0.3).ignoresSafeArea()
            
            // CustomColor.offBlackBackground
            if !isActive {
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("⏱️ \(currentRhythm.totalMinutes.clean) minutes")
                                .font(.largeTitle.bold())
                                .fontDesign(.rounded)
                                
                            Spacer()
                        }
                        
                        // Start suggestion
                        Text(
                            "Start now, and be ready by **\(estimatedEndTime.formatted(date: .omitted, time: .shortened))**")
                    }
                    .padding(.horizontal, 20)
                    .foregroundStyle(.white)
                    
                    // Display the tasks in list view
                    List {
                        ForEach(currentRhythm.tasks.indices, id: \.self) { index in
                            TaskListCell(task: currentRhythm.tasks[index])
                                .listRowSeparator(.hidden, edges: .all)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(Color.clear)
                            
                                // Animation
                                .opacity(showCellAnimation ? 1.0 : 0)
                                .offset(y: showCellAnimation ? 0 : 10)
                                .animation(.bouncy(duration: 0.5).delay(animationDelay * Double(index)), value: showCellAnimation)
                                .padding(.bottom)
                        }
                        .onDelete(perform: { indexSet in
                            for taskIndex in indexSet {
                                let task = currentRhythm.tasks[taskIndex]
                                modelContext.delete(task)
                            }
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    
                    if currentRhythm.tasks.count > 0 {
                        Button {
                            withAnimation {
                                isActive = true
                            }
                        } label: {
                            Text("Start Rhythm")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 60)
                                .background(.white.opacity(0.5))
                                .background(gradient.opacity(1.0))
                                .clipShape(Capsule())
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(currentRhythm: currentRhythm)
                        .presentationDetents([.fraction(0.50)])
                        .presentationDragIndicator(.visible)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Task") {
                            showAddTaskView = true
                        }
                    }
                }
                .onAppear(perform: {
                    withAnimation(.easeIn(duration: 0.8).delay(3.5)) {
                        suggestStart = true
                    }
                    
                    // Because onAppear might execute too early,
                    // before the List view is fully initialized and ready for animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCellAnimation = true
                    }
                })
            } else {
                RhythmStartView(rhythm: currentRhythm)
            }
        }
    }
}

struct TaskListCell: View {
    var task: TaskItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.title2.bold())
                
                if task.minutes == 1.0 {
                    Text("\(task.minutes.clean) minute")
                } else {
                    Text("\(task.minutes.clean) minutes")
                }
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Spacer()
        }
        .foregroundStyle(.black)
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        return RhythmDetailView(currentRhythm: rhythm)
            .modelContainer(container)
    }
}