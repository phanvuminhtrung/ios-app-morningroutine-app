//
//  TimerView.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import SwiftUI

struct TimerView: View {
    @Bindable var rhythmManager: RhythmManager
  
    var body: some View {
        ZStack {
            // MARK: Display timer and progress ring
            ZStack {
                TimerProgressRing(progress: rhythmManager.progress)
                    .containerRelativeFrame(.horizontal) {width, axis in
                        width * 0.8
                    }
                
                VStack {
                    Text(rhythmManager.taskEndTime, style: .timer)
                        .font(.custom("SF Pro", size: 80, relativeTo: .largeTitle))
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                }
            }
            .onReceive(rhythmManager.timer, perform: { _ in
                rhythmManager.track()
            })
        }
    }
}


struct TimerProgressRing: View {
    var progress: Double
    
    let ringColor = Color.white.opacity(0.9)
    let width: Double = 10
    
    var body: some View {
        ZStack {
            // Placeholder Ring
            Circle()
                .stroke (lineWidth: width)
                .foregroundColor(.black.opacity(0.8))
                .opacity (0.1)
            
            // Colored Ring
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(ringColor,style: StrokeStyle( lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(270))
                .animation(.easeInOut(duration: 2.0), value: progress)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return TimerView(rhythmManager: RhythmManager(tasks: rhythm.tasks))
            .modelContainer(container)
    }
}
