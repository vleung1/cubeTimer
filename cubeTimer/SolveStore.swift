//
//  SolveStore.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/1/26.
//

import Foundation
import SwiftUI
import Combine

struct Solve: Codable, Identifiable {
    let id: UUID
    let time: Double
    let date: Date

    init(time: Double) {
        self.id = UUID()
        self.time = time
        self.date = Date()
    }
}

class SolveStore: ObservableObject {
    @Published var solves: [Solve] = [] {
        didSet { save() }
    }

    var overallAverage: Double? {
        guard !solves.isEmpty else { return nil }
        return solves.map(\.time).reduce(0, +) / Double(solves.count)
    }

    var last10Average: Double? {
        let recent = solves.suffix(10)
        guard !recent.isEmpty else { return nil }
        return recent.map(\.time).reduce(0, +) / Double(recent.count)
    }

    var bestTime: Double? {
        solves.map(\.time).min()
    }

    init() { load() }

    func addSolve(_ time: Double) {
        solves.append(Solve(time: time))
    }

    func deleteSolve(at offsets: IndexSet) {
        let actualOffsets = IndexSet(offsets.map { solves.count - 1 - $0 })
        solves.remove(atOffsets: actualOffsets)
    }

    func deleteAll() {
        solves.removeAll()
    }

    func generateCSV() -> String {
        var csv = "Solve Number,Date,Formatted Time,Seconds\n"
        let dateFormatter = ISO8601DateFormatter()
        for (index, solve) in solves.reversed().enumerated() {
            let solveNum = solves.count - index
            let formatted = formatTime(solve.time)
            let seconds = String(format: "%.2f", solve.time)
            csv += "\(solveNum),\(dateFormatter.string(from: solve.date)),\"\(formatted)\",\(seconds)\n"
        }
        return csv
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let centiseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, seconds, centiseconds)
        }
        return String(format: "%02d.%02d", seconds, centiseconds)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(solves) {
            UserDefaults.standard.set(data, forKey: "solves")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "solves"),
           let decoded = try? JSONDecoder().decode([Solve].self, from: data) {
            solves = decoded
        }
    }
}
