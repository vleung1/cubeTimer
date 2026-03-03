//
//  ProgressChartView.swift
//  cubeTimer
//
//  Created by Vincent Leung on 3/2/26.
//

import SwiftUI
import Charts

struct ProgressChartView: View {
    let solves: [Solve]
    let average: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Progress")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if solves.isEmpty {
                Text("No data yet — start solving!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            } else {
                Chart {
                    ForEach(Array(solves.enumerated()), id: \.offset) { index, solve in
                        LineMark(
                            x: .value("Solve", index + 1),
                            y: .value("Time", solve.time)
                        )
                        .foregroundStyle(Color.blue)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Solve", index + 1),
                            y: .value("Time", solve.time)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.25), Color.blue.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Solve", index + 1),
                            y: .value("Time", solve.time)
                        )
                        .foregroundStyle(Color.blue)
                        .symbolSize(solves.count > 30 ? 10 : 30)
                    }

                    if let avg = average {
                        RuleMark(y: .value("Average", avg))
                            .foregroundStyle(Color.orange)
                            .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("avg \(formatTime(avg))")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let t = value.as(Double.self) {
                                Text(formatTime(t))
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let v = value.as(Int.self) {
                                Text("#\(v)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(height: 180)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
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
