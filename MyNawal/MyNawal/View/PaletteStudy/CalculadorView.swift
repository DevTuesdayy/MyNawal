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
        VStack(spacing: 12) {
            Text("Calcula tu Nawal")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.mamFondo)
            Text("Ingresa tu fecha de nacimiento")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Fecha de nacimiento")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mamFondo)
                
                DatePicker(
                    "",
                    selection: $selectDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(Color.mamJade)
                .opacity(0.02)
                .frame(height: 60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    HStack {
                        Text(dateFormatter.string(from: selectDate))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.mamJade)
                    }
                    .allowsHitTesting(false)
                    .padding(.horizontal, 22)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.mamFondo.opacity(0.22), lineWidth: 1.5)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 520)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.mamBlanco, Color.mamBlanco.opacity(0.94)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    CalculadorView()
}
