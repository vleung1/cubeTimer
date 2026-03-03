//
//  SolveListView.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/1/26.
//


import SwiftUI

struct SolveListView: View {
    @ObservedObject var store: SolveStore
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirm = false

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yyyy h:mm a"
        return f
    }()

    var body: some View {
        NavigationStack {
            List {
                if store.solves.isEmpty {
                    Text("No solves yet. Start solving!")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(store.solves.reversed().enumerated()), id: \.offset) { index, solve in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Solve \(store.solves.count - index)")
                                    .font(.body)
                                Text(dateFormatter.string(from: solve.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(formatTime(solve.time))
                                .font(.body.monospaced())
                        }
                    }
                    .onDelete { offsets in
                        let actualOffsets = IndexSet(offsets.map { store.solves.count - 1 - $0 })
                        store.solves.remove(atOffsets: actualOffsets)
                    }
                }
            }
            .navigationTitle("All Solves (\(store.solves.count))")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if !store.solves.isEmpty {
                            ShareLink(item: store.generateCSV(), preview: SharePreview("CubeTimer_Solves.csv")) {
                                Label("Export CSV", systemImage: "square.and.arrow.up")
                            }
                            Button(role: .destructive, action: { showDeleteConfirm = true }) {
                                Label("Delete All", systemImage: "trash")
                            }
                        }
                        Button("Done") { dismiss() }
                    }
                }
            }
            .confirmationDialog("Delete all solves?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("Delete All", role: .destructive) {
                    store.deleteAll()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
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
