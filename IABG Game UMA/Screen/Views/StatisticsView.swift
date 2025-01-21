//
//  StatisticsView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 28/12/24.
//

import SwiftUI

struct StatisticsView: View {
    @Binding var path: [Constants.NavigationDestination]
    @ObservedObject var statisticsVM: StatisticsVM
    @State private var selectedColor = "Red"
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: NSLocalizedString("Statistics", comment: "")) {
                path.removeAll()
            }
            Form {
                statisticsSection(title: NSLocalizedString("Your level:", comment: "") , content: {
                    statisticsRow(leftText: statisticsVM.levelText.bold(),
                                  rightText: statisticsVM.levelMessage)
                })
                
                statisticsSection(title: NSLocalizedString("Your Ranking", comment: ""), subtitle:NSLocalizedString("Total experience", comment: "")) {
                    statisticsRow(leftText: Text("\(statisticsVM.staticticsModel.ranking)º"),
                                  rightText: Text("\(statisticsVM.staticticsModel.points) xp"))
                }
                
                statisticsSection(title: NSLocalizedString("Hits on level", comment: ""), subtitle:NSLocalizedString("Total hits", comment: "")) {
                    statisticsRow(leftText: Text("\(statisticsVM.staticticsModel.levelAttemps) / \(statisticsVM.staticticsModel.levelSuccess)"),
                                  rightText: Text("\(statisticsVM.staticticsModel.totalAttemps) / \(statisticsVM.staticticsModel.totalSucces)"))
                }
                
                statisticsSection(title: NSLocalizedString("% of Accert", comment: ""), subtitle:NSLocalizedString("% of Agility", comment: "")) {
                    statisticsRow(leftText: Text("\(statisticsVM.staticticsModel.percentajeAccert, specifier: "%.0f") %"),
                                  rightText: Text("\(statisticsVM.staticticsModel.percentajeCapture, specifier: "%.0f") %"))
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Last Games").bold()
                        Spacer()
                    }
                    ForEach(statisticsVM.staticticsModel.lastPlays.prefix(4), id: \.self) { point in
                        let color = statisticsVM.getColor(for: point)
                        lastGameRow(score: point, color: color)
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color("FirstGreen"))
                        Text(statisticsVM.suggestionText)
                    }
                }
                
                Button {
                    statisticsVM.exportStatistics()
                } label: {
                    Text("Exportar estadísticas")
                }
                .buttonStyle(SecondaryButton())
                .padding(16)
            }
            .background(Color("SecondBlue"))
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $statisticsVM.showShareSheet) {
                if let pdfURL = statisticsVM.pdfURL {
                    ShareSheet(activityItems: [pdfURL])
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Subviews

private extension StatisticsView {
    
    func statisticsSection(title: String, subtitle: String? = nil, @ViewBuilder content: () -> some View) -> some View {
        Section {
            if let subtitle = subtitle {
                HStack {
                    Text(title).bold()
                    Spacer()
                    Text(subtitle).bold()
                }
            } else {
                Text(title).bold()
            }
            content()
        }
    }
    
    func statisticsRow(leftText: Text, rightText: Text) -> some View {
        HStack {
            leftText
            Spacer()
            rightText
        }
    }
    
    func lastGameRow(score: Int, color: Color) -> some View {
        HStack {
            Text("\(score)%")
                .frame(width: 100, height: 30, alignment: .center)
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(color)
                .bold()
                .frame(width: 100, height: 30, alignment: .center)
        }
    }
}

#Preview {
    NavigationStack {
        StatisticsView(
            path: .constant([]),
            statisticsVM: StatisticsVM(staticticsModel: StatisticsModel(
                level: .medium,
                totalAttemps: 456,
                totalSucces: 34,
                levelAttemps: 200,
                levelSuccess: 14,
                ranking: 4,
                points: 40000,
                lastPlays: [1, 99, 45, 6, 12, 15],
                percentajeAccert: 13.9,
                percentajeCapture: 70.8
            ))
        )
    }
}
