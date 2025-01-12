//
//  ShareSheet.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 12/1/25.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


func createCustomPDF(statistic: StatisticsModel, recomendation: String) -> URL? {
    // Configuración del archivo PDF
    let pdfFileName = "StatisticPDF.pdf"
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let pdfURL = documentDirectory.appendingPathComponent(pdfFileName)

    // Tamaño de la página PDF (A4)
    let pageWidth: CGFloat = 612
    let pageHeight: CGFloat = 792
    let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

    do {
        try pdfRenderer.writePDF(to: pdfURL) { context in
            context.beginPage()

            let margin: CGFloat = 20
            var currentY: CGFloat = margin

            // Logo
            if let image = UIImage(named: "cutIcon") {
                let imageWidth: CGFloat = 250
                let imageHeight: CGFloat = 100
                let imageX = (pageWidth - imageWidth) / 2
                let imageRect = CGRect(x: imageX, y: currentY, width: imageWidth, height: imageHeight)
                image.draw(in: imageRect)
                currentY += imageHeight + 10
            }

            // Titulo
            let title = NSLocalizedString("Informe estadístico", comment: "")
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            let titleSize = title.size(withAttributes: titleAttributes)
            let titleX = (pageWidth - titleSize.width) / 2
            title.draw(at: CGPoint(x: titleX, y: currentY), withAttributes: titleAttributes)
            currentY += titleSize.height + 10

            let user = UserDefaults.getUser() ?? UserModel(userID: "", userName: "", pwd: "", email: "")

            // Subtítulo
            let stringsubtitle =  NSLocalizedString("Usuario", comment: "")
            let subtitle = stringsubtitle + " : " + user.email
            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.darkGray
            ]

            let cols1Attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]

            let subtitleSize = subtitle.size(withAttributes: subtitleAttributes)
            let subtitleX = (pageWidth - subtitleSize.width) / 2
            subtitle.draw(at: CGPoint(x: subtitleX, y: currentY), withAttributes: subtitleAttributes)
            currentY += subtitleSize.height + 10

            let stringsubtitle2 =  NSLocalizedString("Fecha", comment: "")
            let subtitle2 = stringsubtitle2 + " : " + "\(Date())"
            let subtitleAttributes2: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.darkGray
            ]
            let subtitleSize2 = subtitle2.size(withAttributes: subtitleAttributes2)
            let subtitleX2 = (pageWidth - subtitleSize2.width) / 2
            subtitle2.draw(at: CGPoint(x: subtitleX2, y: currentY), withAttributes: subtitleAttributes2)
            currentY += subtitleSize2.height + 20

            // Tabla
            let tableColumnWidth = (pageWidth - 2 * margin) / 2
            let elements = getTableElements(statistic: statistic, recomendation: recomendation)
            let cols1 = Array(elements.keys.sorted())
            let cols2 = getSortedValues(elements: elements)

            // Estilo de texto con saltos de línea
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left

            let dynamicCols1Attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: paragraphStyle
            ]

            let dynamicCols2Attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: paragraphStyle
            ]

            for row in 0..<elements.count {
                let col1Text = "\(cols1[row])"
                let col2Text = "\(cols2[row])"

                // Calcula el tamaño requerido para cada columna
                let col1Size = col1Text.boundingRect(
                    with: CGSize(width: tableColumnWidth - 10, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: dynamicCols1Attributes,
                    context: nil
                )
                let col2Size = col2Text.boundingRect(
                    with: CGSize(width: tableColumnWidth - 10, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: dynamicCols2Attributes,
                    context: nil
                )

                // Determina la altura de la fila en función del contenido más alto
                let rowHeight = max(col1Size.height, col2Size.height) + 10
                
                let col1Rect = CGRect(x: margin, y: currentY, width: tableColumnWidth, height: rowHeight)
                let col2Rect = CGRect(x: margin + tableColumnWidth, y: currentY, width: tableColumnWidth, height: rowHeight)

                context.cgContext.stroke(col1Rect)
                context.cgContext.stroke(col2Rect)

                col1Text.draw(in: col1Rect.insetBy(dx: 5, dy: 5), withAttributes: dynamicCols1Attributes)
                col2Text.draw(in: col2Rect.insetBy(dx: 5, dy: 5), withAttributes: dynamicCols2Attributes)

                currentY += rowHeight
            }
        }
    } catch {
        print("Error al generar el PDF: \(error.localizedDescription)")
        return nil
    }

    return pdfURL
}


private func getTableElements(statistic: StatisticsModel, recomendation: String) -> [String: String] {
    
    var lastGames = ""
    statistic.lastPlays.prefix(6).forEach{ play in
        lastGames += "\(statistic.percentajeCapture) %  |  "
    }
    
    let result: [String: String]  = [NSLocalizedString("Your level:", comment: "") : getLevelName(statistic.level),
                                     NSLocalizedString("Your Ranking", comment: ""): "\(statistic.ranking)º",
                                     NSLocalizedString("Total experience", comment: ""): "\(statistic.points) xp",
                                     NSLocalizedString("Hits on level", comment: ""): "\(statistic.levelAttemps) / \(statistic.levelSuccess)" ,
                                     NSLocalizedString("Total hits", comment: ""): "\(statistic.totalAttemps) / \(statistic.totalSucces)",
                                     NSLocalizedString("% of Accert", comment: ""): "\(statistic.percentajeAccert) %",
                                     NSLocalizedString("% of Agility", comment: ""):"\(statistic.percentajeCapture) %",
                                     NSLocalizedString("Last Games", comment:""): lastGames,
                                     NSLocalizedString("Recomendación", comment:""): recomendation
                                ]
    
    return result
}

private func getSortedValues(elements: [String: String]) -> [String] {
    let sortedKeys = elements.keys.sorted()
    var sortedValues: [String] = []
    for key in sortedKeys {
        sortedValues.append(elements[key]!)
    }
    
    return sortedValues
}
