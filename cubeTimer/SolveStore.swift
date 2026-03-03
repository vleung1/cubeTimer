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
        var csv = "Solve Number,Date,Time\n"
        let dateFormatter = ISO8601DateFormatter()
        for (index, solve) in solves.reversed().enumerated() {
            let solveNum = solves.count - index
            csv += "\(solveNum),\(dateFormatter.string(from: solve.date)),\(solve.time)\n"
        }
        return csv
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
