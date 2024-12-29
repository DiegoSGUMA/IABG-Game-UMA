//
//  ResultinfoView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import SwiftUI

struct ResultInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            infoText("**Total** = Total de elementos en la partida")
            infoText("**3 - 5** = **3** (Predicción introducida por el jugador) y **5** (Elementos reales que ha cogido en la partida)")

            predictionLegend(color: Color("LowLevel"), description: "Predicción no acertada y no has cogido todos los elementos en la partida")
            predictionLegend(color: Color("MediumLevel"), description: "Predicción acertada y no has cogido todos los elementos en la partida")
            predictionLegend(color: Color("HardLevel"), description: "Predicción acertada y has cogido todos los elementos en la partida")
            
            Spacer()
        }
        .padding()
    }
    
    // Subvista para mostrar texto de información
    private func infoText(_ text: String) -> some View {
        Text(text)
            .lineLimit(nil)
            .padding(.horizontal)
    }

    // Subvista para mostrar leyenda de predicciones con círculos de colores
    private func predictionLegend(color: Color, description: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(description)
                .lineLimit(nil)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ResultInfoView()
}
