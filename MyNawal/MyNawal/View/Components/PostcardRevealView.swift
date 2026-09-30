import SwiftUI

/// Presentation only: exports and customization use the fully visible defaults.
struct PostcardRevealState {
    var photo: Double = 1
    var border: CGFloat = 1
    var frame: Double = 1
    var stamp: Double = 1

    static let complete = Self()
    static let concealed = Self(photo: 0, border: 0, frame: 0, stamp: 0)
}

struct PostcardRevealView: View {
    let draft: NawalPostcardDraft
    let selfieImage: UIImage
    let appearance: PostcardAppearance
    let revealID: UUID?
    let waitingForCameraDismissal: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var reveal = PostcardRevealState.complete
    @State private var handledID: UUID?

    private struct Request: Equatable {
        let id: UUID?
        let waiting: Bool
        let reduceMotion: Bool
    }

    var body: some View {
        NawalPostcardCanvas(
            draft: draft,
            selfieImage: selfieImage,
            appearance: appearance,
            reveal: waitingForCameraDismissal && !reduceMotion ? .concealed : reveal
        )
        .task(id: Request(id: revealID, waiting: waitingForCameraDismissal, reduceMotion: reduceMotion)) {
            guard let revealID, !reduceMotion else {
                // Consume the event even with Reduce Motion so enabling motion later
                // does not unexpectedly replay an already confirmed postcard.
                handledID = revealID
                finishImmediately()
                return
            }
            guard !waitingForCameraDismissal else { return }
            guard handledID != revealID else {
                finishImmediately()
                return
            }
            handledID = revealID
            reveal = .concealed

            do {
                // Let the concealed state reach the screen before revealing the photo.
                try await Task.sleep(for: .milliseconds(30))
                withAnimation(.easeOut(duration: 0.3)) { reveal.photo = 1 }
                try await Task.sleep(for: .milliseconds(170))
                withAnimation(.easeInOut(duration: 0.5)) { reveal.border = 1 }
                try await Task.sleep(for: .milliseconds(500))
                withAnimation(.easeOut(duration: 0.18)) { reveal.frame = 1 }
                withAnimation(.spring(duration: 0.36, bounce: 0.2)) { reveal.stamp = 1 }
            } catch {
                // SwiftUI cancels this short sequence on exit or when a new photo arrives.
            }
        }
        .onDisappear { finishImmediately() }
    }

    private func finishImmediately() {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        withTransaction(transaction) { reveal = .complete }
    }
}
