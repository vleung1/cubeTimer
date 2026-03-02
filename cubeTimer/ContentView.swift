//
//  ContentView.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/1/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = SolveStore()
    @State private var isRunning = false
    @State private var elapsedTime: Double = 0
    @State private var startTime: Date?
    @State private var timer: Timer?
    @State private var showList = false

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd h:mm a"
        return f
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Stats
                HStack(spacing: 30) {
                    StatView(label: "Overall Avg", value: store.overallAverage)
                    StatView(label: "Last 10 Avg", value: store.last10Average)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)

                // Timer Display
                Text(formatTime(elapsedTime))
                    .font(.system(size: 72, weight: .thin, design: .monospaced))
                    .foregroundColor(isRunning ? .green : .primary)
                    .padding(.bottom, 20)

                // Big tap button
                Button(action: handleTap) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isRunning ? Color.red.opacity(0.15) : Color.blue.opacity(0.15))
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isRunning ? Color.red : Color.blue, lineWidth: 3)
                        Text(isRunning ? "STOP" : (elapsedTime > 0 ? "NEXT" : "START"))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(isRunning ? .red : .blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Reset button
                if !isRunning && elapsedTime > 0 {
                    Button("Reset Timer") {
                        elapsedTime = 0
                    }
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                }

                // Scrollable last 10 table
                if !store.solves.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Last 10 Solves")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top, 12)
                            .padding(.bottom, 6)

                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Array(store.solves.suffix(10).reversed().enumerated()), id: \.offset) { index, solve in
                                    HStack {
                                        Text("#\(store.solves.count - index)")
                                            .font(.caption.monospaced())
                                            .foregroundColor(.secondary)
                                            .frame(width: 36, alignment: .leading)
                                        Text(dateFormatter.string(from: solve.date))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(formatTime(solve.time))
                                            .font(.body.monospaced())
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(index % 2 == 0 ? Color(.secondarySystemBackground) : Color(.systemBackground))
                                }
                            }
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Cube Timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showList = true }) {
                        Label("Solves", systemImage: "list.number")
                    }
                }
            }
            .sheet(isPresented: $showList) {
                SolveListView(store: store)
            }
        }
    }

    func handleTap() {
        if isRunning {
            stopTimer()
            store.addSolve(elapsedTime)
        } else {
            elapsedTime = 0
            startTimer()
        }
    }

    func startTimer() {
        isRunning = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let centiseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, seconds, centiseconds)
        }
        return String(format: "%02d.%02d", seconds, centiseconds)
    }
}

struct StatView: View {
    let label: String
    let value: Double?

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value.map { formatTime($0) } ?? "--")
                .font(.title3.bold().monospaced())
        }
        .frame(minWidth: 120)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let centiseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, seconds, centiseconds)
        }
        return String(format: "%02d.%02d", seconds, centiseconds)
    }
}
