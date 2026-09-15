//
//  CalculadorView.swift
//  MyNawal
//
//  Created by Alan Cervantes on 09/09/26.
//

import SwiftUI

struct CalculadorView: View {
    
    @State private var selectDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Calcula tu Nawal")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamFondo)
                    .accessibilityAddTraits(.isHeader)
                Text("Ingresa tu fecha de nacimiento")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.75))
                    .multilineTextAlignment(.center)

                SeparadorHilos()
                    .padding(.top, 4)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 40)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Fecha de nacimiento")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mamFondo)
                
                DatePicker(
                    "Fecha de nacimiento",
                    selection: $selectDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "es_MX"))
                .labelsHidden()
                .tint(Color.mamJade)
                .opacity(0.02)
                .frame(height: 64)
                .frame(maxWidth: .infinity, alignment: .leading)
                .superficieEstuco()
                .overlay {
                    HStack {
                        Text(dateFormatter.string(from: selectDate))
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .minimumScaleFactor(0.75)
                            .lineLimit(1)
                            .foregroundStyle(Color.mamFondo)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.mamJade)
                    }
                    .allowsHitTesting(false)
                    .padding(.horizontal, 22)
                }
            }

            Spacer(minLength: 40)
                .frame(maxHeight: 160)

            Button {
                print("Calculando")
            } label: {
                Text("Calcular mi Nawal")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.mamBlanco)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.mamJade)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.mamArena, lineWidth: 1)
                    }
                    .shadow(color: Color.mamFondo.opacity(0.09), radius: 2, x: 0, y: 2)
            }
            .buttonStyle(NawalPressStyle())
        }
        .padding(.top, 24)
        .padding(.bottom, 24)
        .padding(.horizontal, 24)
        .frame(maxWidth: 520)
        .nawalEntrance()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .background(
            FondoEstuco().ignoresSafeArea()
        )
    }
}

#Preview {
    CalculadorView()
}
