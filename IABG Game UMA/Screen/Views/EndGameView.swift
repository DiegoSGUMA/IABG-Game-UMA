//
//  EndGameView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import SwiftUI

struct EndGameView: View {
    @Binding var path: [Constants.NavigationDestination]
    @ObservedObject var endGameVM: EndGameVM
    @State private var showInfoSheet: Bool = false
    
    var body: some View {
        VStack {
            if !endGameVM.comprobe {
                VStack(spacing: 15) {
                    Text("¡Enhorabuena, has finalizado una partida con éxito!")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                    
                    Text("Por favor, introduce el número que has encestado de cada elemento en las siguientes casillas.")
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 15)
            } else {
                VStack(spacing: 10) {
                    resultText(title: "Porcentaje de aciertos en predicciones", value: endGameVM.percentajeAccert)
                    resultText(title: "Porcentaje de aciertos en agilidad", value: endGameVM.percentajeCapture)
                    resultText(title: "Puntuación de la partida", value: endGameVM.percentageGlobal, isLarge: true)
                }
            }
            
            Spacer()
            
            List {
                Section(header: sectionHeaderView) {
                    ForEach(endGameVM.elements, id: \.self) { element in
                        GridResultView(
                            element: element,
                            result: binding(for: element.index),
                            checked: $endGameVM.comprobe
                        )
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .background(Color("SecondBlue"))
            
            Spacer()
            
            Button {
                if endGameVM.comprobe {
                    endGameVM.saveResults()
                } else {
                    endGameVM.comprobe.toggle()
                    endGameVM.save()
                }
            } label: {
                Text(endGameVM.comprobe ? "Ir al inicio" : "Ver resultados")
            }
            .buttonStyle(MainButton())
        }
        .padding()
        .toolbar(.hidden)
        .background(Color("SecondBlue"))
        .sheet(isPresented: $showInfoSheet) {
            ResultInfoView()
                .presentationDetents([.medium, .large])
                .background(Color("Button_Medium").edgesIgnoringSafeArea(.all))
        }
        .alert("App Warning", isPresented: $endGameVM.showAlert) {
            Button("Ir al inicio") {
                path.removeAll()
            }
        } message: {
            Text(endGameVM.msg)
        }
    }
    
    private var sectionHeaderView: some View {
        HStack {
            Text("RESULTADOS")
                .font(.title2.bold())
            
            if endGameVM.comprobe {
                Button {
                    showInfoSheet.toggle()
                } label: {
                    Image(systemName: "info.square")
                        .symbolEffect(.pulse, isActive: true)
                        .frame(width: 25)
                }
            }
        }
    }
    
    private func resultText(title: String, value: Double, isLarge: Bool = false) -> some View {
        VStack {
            Text(title).bold()
            Text(String(format: "%.0f %%", value.rounded()))
                .font(isLarge ? .title.bold() : .body)
                .padding(.bottom, 10)
        }
    }
    
    private func binding(for index: Int) -> Binding<Int> {
        switch index {
        case 1: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 0)
        case 2: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 1)
        case 3: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 2)
        case 4: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 3)
        case 5: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 4)
        case 6: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 5)
        case 7: return endGameVM.bindingForIndex(array: $endGameVM.icons, index: 6)
        default: return .constant(0)
        }
    }
    
}

#Preview {
    EndGameView(
        path: .constant([]),
        endGameVM: EndGameVM(
            elements: [
                EndGameModel(index: 1, realResult: 2, totalElements: 4, posibleResult: 3),
                EndGameModel(index: 2, realResult: 5, totalElements: 5, posibleResult: 3),
                EndGameModel(index: 3, realResult: 3, totalElements: 6, posibleResult: 1)
            ]
        )
    )
}
