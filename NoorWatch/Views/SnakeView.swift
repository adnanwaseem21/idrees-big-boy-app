import SwiftUI

/// The classic Nokia Snake, on the watch. Fully offline.
/// Steer by swiping, or tap the Digital Crown-free arrow pads.
@MainActor
final class SnakeGame: ObservableObject {
    static let cols = 13
    static let rows = 13

    enum Dir { case up, down, left, right
        var dx: Int { self == .left ? -1 : self == .right ? 1 : 0 }
        var dy: Int { self == .up ? -1 : self == .down ? 1 : 0 }
        var opposite: Dir { switch self { case .up: .down; case .down: .up; case .left: .right; case .right: .left } }
    }

    struct Cell: Equatable { var x: Int; var y: Int }

    @Published var snake: [Cell] = []
    @Published var food = Cell(x: 6, y: 6)
    @Published var score = 0
    @Published var best = UserDefaults.standard.integer(forKey: "snakeBest")
    @Published var running = false
    @Published var gameOver = false

    private var dir: Dir = .right
    private var pendingDir: Dir = .right
    private var timer: Timer?

    func start() {
        snake = [Cell(x: 4, y: 6), Cell(x: 3, y: 6), Cell(x: 2, y: 6)]
        dir = .right
        pendingDir = .right
        score = 0
        gameOver = false
        running = true
        placeFood()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.28, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.step() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        running = false
    }

    func turn(_ newDir: Dir) {
        // Can't reverse directly onto yourself.
        guard newDir != dir.opposite else { return }
        pendingDir = newDir
    }

    private func step() {
        dir = pendingDir
        guard var head = snake.first else { return }
        head = Cell(x: head.x + dir.dx, y: head.y + dir.dy)

        let hitWall = head.x < 0 || head.y < 0 || head.x >= Self.cols || head.y >= Self.rows
        if hitWall || snake.contains(head) {
            end()
            return
        }

        snake.insert(head, at: 0)
        if head == food {
            score += 1
            Haptics.success()
            placeFood()
        } else {
            snake.removeLast()
        }
    }

    private func placeFood() {
        var spot = food
        repeat {
            spot = Cell(x: Int.random(in: 0..<Self.cols), y: Int.random(in: 0..<Self.rows))
        } while snake.contains(spot)
        food = spot
    }

    private func end() {
        stop()
        gameOver = true
        Haptics.tap()
        if score > best {
            best = score
            UserDefaults.standard.set(best, forKey: "snakeBest")
        }
    }
}

struct SnakeView: View {
    @StateObject private var game = SnakeGame()

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let cell = side / CGFloat(SnakeGame.cols)
            VStack(spacing: 4) {
                HStack {
                    Text("Score \(game.score)").font(.caption2)
                    Spacer()
                    Text("Best \(game.best)").font(.caption2).foregroundStyle(.secondary)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.12))
                    // Food
                    cellRect(game.food, cell: cell, color: .orange)
                    // Snake
                    ForEach(Array(game.snake.enumerated()), id: \.offset) { index, part in
                        cellRect(part, cell: cell, color: index == 0 ? .green : .green.opacity(0.75))
                    }
                    if !game.running {
                        overlay
                    }
                }
                .frame(width: cell * CGFloat(SnakeGame.cols), height: cell * CGFloat(SnakeGame.rows))
                .contentShape(Rectangle())
                .gesture(swipe)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Snake")
        .onDisappear { game.stop() }
    }

    private var overlay: some View {
        VStack(spacing: 6) {
            Text(game.gameOver ? "Game Over" : "🐍 Snake").font(.headline)
            if game.gameOver { Text("Score \(game.score)").font(.caption) }
            Button(game.gameOver ? "Play again" : "Start") { game.start() }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            Text("Swipe to steer").font(.caption2).foregroundStyle(.secondary)
        }
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }

    private func cellRect(_ c: SnakeGame.Cell, cell: CGFloat, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: cell - 1.5, height: cell - 1.5)
            .position(x: (CGFloat(c.x) + 0.5) * cell, y: (CGFloat(c.y) + 0.5) * cell)
    }

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 12)
            .onEnded { value in
                guard game.running else { return }
                let dx = value.translation.width
                let dy = value.translation.height
                if abs(dx) > abs(dy) {
                    game.turn(dx > 0 ? .right : .left)
                } else {
                    game.turn(dy > 0 ? .down : .up)
                }
            }
    }
}
