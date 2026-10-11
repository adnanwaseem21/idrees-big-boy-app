import SwiftUI

/// A row of S M T W T F S toggles for choosing which weekdays something runs.
struct DaysPicker: View {
    @Binding var days: [Int]   // 1 = Sunday ... 7 = Saturday

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...7, id: \.self) { day in
                let on = days.contains(day)
                Button {
                    if on { days.removeAll { $0 == day } } else { days.append(day); days.sort() }
                } label: {
                    Text(Weekday.names[day - 1])
                        .font(.caption.bold())
                        .frame(width: 30, height: 30)
                        .background(on ? Color.accentColor : Color.secondary.opacity(0.15))
                        .foregroundStyle(on ? .white : .secondary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// A Date <-> (hour, minute) bridge so a SwiftUI time picker can edit ints.
extension Binding where Value == Date {
    static func time(hour: Binding<Int>, minute: Binding<Int>) -> Binding<Date> {
        Binding<Date>(
            get: {
                Calendar.current.date(bySettingHour: hour.wrappedValue,
                                      minute: minute.wrappedValue, second: 0, of: Date()) ?? Date()
            },
            set: { newValue in
                let parts = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                hour.wrappedValue = parts.hour ?? 0
                minute.wrappedValue = parts.minute ?? 0
            }
        )
    }
}

/// A small inline emoji field.
struct EmojiField: View {
    let title: String
    @Binding var emoji: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField("🙂", text: $emoji)
                .multilineTextAlignment(.trailing)
                .frame(width: 44)
        }
    }
}
