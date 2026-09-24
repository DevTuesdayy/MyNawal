import SwiftUI
import UIKit

struct WelcomeView: View {
    let onContinue: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var frameProgress: CGFloat = 0
    @State private var showsIcon = false
    @State private var expandsHalo = false
    @State private var showsText = false
    @State private var showsButton = false
    @State private var hasStarted = false
    @State private var hasRequestedExit = false

    var body: some View {
        GeometryReader { proxy in
            let compact = proxy.size.height < 720 || dynamicTypeSize.isAccessibilitySize
            let iconSize = min(proxy.size.width * 0.46, compact ? 136 : 184)

            ZStack {
                FondoEstuco()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [
                        Color.mamArena.opacity(0.08),
                        Color.clear,
                        Color.mamJade.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .accessibilityHidden(true)

                WelcomeThreadFrame(progress: frameProgress)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)


                VStack(spacing: compact ? 14 : 20) {
                    Spacer(minLength: compact ? 28 : 52)

                    VStack(spacing: compact ? 14 : 20) {
                        WelcomeThreadMotif(progress: frameProgress)

                        ZStack {
                            Circle()
                                .fill(Color.mamAmarillo.opacity(0.12))
                                .frame(width: iconSize * 1.26, height: iconSize * 1.26)
                                .scaleEffect(expandsHalo ? 1.16 : 0.72)
                                .opacity(showsIcon ? (expandsHalo ? 0 : 0.8) : 0)

                            Circle()
                                .strokeBorder(Color.mamArena.opacity(0.65), lineWidth: 1)
                                .frame(width: iconSize * 1.12, height: iconSize * 1.12)
                                .scaleEffect(showsIcon ? 1 : 0.72)
                                .opacity(showsIcon ? 1 : 0)

                            welcomeIcon(size: iconSize)
                                .scaleEffect(showsIcon ? 1 : 0.72)
                                .rotationEffect(.degrees(showsIcon ? 0 : -4))
                                .opacity(showsIcon ? 1 : 0)
                        }

                        VStack(spacing: 9) {
                            Text("My Nawal")
                                .font(.system(compact ? .title : .largeTitle, design: .rounded, weight: .bold))
                                .foregroundStyle(Color.mamFondo)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .accessibilityAddTraits(.isHeader)

                            SeparadorHilos()

                            Text("Conoce tu energía • Honra tu origen")
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .foregroundStyle(Color.mamFondo.opacity(secondaryContentOpacity))
                                .multilineTextAlignment(.center)
                                .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 2)
                                .minimumScaleFactor(0.65)

                            Text("RAÍCES  •  ENERGÍA  •  COMUNIDAD")
                                .font(.system(size: compact ? 9 : 10, weight: .semibold, design: .rounded))
                                .tracking(1.15)
                                .foregroundStyle(Color.mamRojo.opacity(accentContentOpacity))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .offset(y: showsText ? 0 : 12)
                        .opacity(showsText ? 1 : 0)
                        .accessibilityHidden(!showsText)
                    }

                    Spacer(minLength: compact ? 20 : 36)

                    Button(action: requestExit) {
                        Label("Entrar", systemImage: "arrow.right")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color.mamBlanco)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .strokeBorder(Color.mamArena, lineWidth: 1)
                            }
                    }
                    .buttonStyle(NawalPressStyle())
                    .accessibilityHint("Abre el catálogo de nawales")
                    .opacity(showsButton ? 1 : 0)
                    .offset(y: showsButton ? 0 : 10)
                    .allowsHitTesting(showsButton)
                    .accessibilityHidden(!showsButton)
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 32)
                .padding(.vertical, compact ? 24 : 34)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await playEntrance()
        }
    }

    @MainActor
    private func playEntrance() async {
        guard !hasStarted else { return }
        hasStarted = true

        if reduceMotion {
            frameProgress = 1
            showsIcon = true
            showsText = true
            showsButton = true
            return
        }

        withAnimation(.easeInOut(duration: 0.72)) {
            frameProgress = 1
        }

        do { try await Task.sleep(for: .milliseconds(260)) } catch { return }
        withAnimation(.spring(response: 0.62, dampingFraction: 0.78)) {
            showsIcon = true
        }

        do { try await Task.sleep(for: .milliseconds(80)) } catch { return }
        withAnimation(.easeOut(duration: 0.82)) {
            expandsHalo = true
        }

        do { try await Task.sleep(for: .milliseconds(310)) } catch { return }
        withAnimation(.easeOut(duration: 0.44)) {
            showsText = true
        }

        do { try await Task.sleep(for: .milliseconds(280)) } catch { return }
        withAnimation(.easeOut(duration: 0.32)) {
            showsButton = true
        }

        do { try await Task.sleep(for: .milliseconds(850)) } catch { return }
        guard !Task.isCancelled else { return }
        requestExit()
    }

    @MainActor
    private func requestExit() {
        guard !hasRequestedExit else { return }
        hasRequestedExit = true
        onContinue()
    }

    private var secondaryContentOpacity: Double {
        colorSchemeContrast == .increased ? 1 : 0.75
    }

    private var accentContentOpacity: Double {
        colorSchemeContrast == .increased ? 1 : 0.82
    }

    @ViewBuilder
    private func welcomeIcon(size: CGFloat) -> some View {
        if let icon = UIImage(named: "WelcomeAppIcon") {
            Image(uiImage: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                        .strokeBorder(Color.mamArena, lineWidth: 2)
                }
                .shadow(color: Color.mamFondo.opacity(0.18), radius: 9, y: 5)
                .accessibilityHidden(true)
        } else {
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.36, weight: .light))
                .foregroundStyle(Color.mamJade)
                .frame(width: size, height: size)
                .background(Color.mamArena.opacity(0.18), in: RoundedRectangle(cornerRadius: size * 0.22))
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
