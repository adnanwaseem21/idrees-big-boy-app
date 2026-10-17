import Foundation
import CoreLocation
import Adhan

/// Prayer times are pure math on the date and the watch's last known
/// location, so they work with no internet at all.
@MainActor
final class PrayerService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var coordinates: Coordinates
    /// Compass direction the watch is facing, in degrees from north.
    @Published private(set) var heading: Double?

    private let manager = CLLocationManager()

    override init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "lastLatitude") != nil {
            coordinates = Coordinates(latitude: defaults.double(forKey: "lastLatitude"),
                                      longitude: defaults.double(forKey: "lastLongitude"))
        } else {
            coordinates = Coordinates(latitude: FamilyConfig.fallbackLatitude,
                                      longitude: FamilyConfig.fallbackLongitude)
        }
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // MARK: Prayer times

    func times(on date: Date) -> DayTimes? {
        var params = FamilyConfig.calculationMethod.params
        params.madhab = FamilyConfig.madhab
        let day = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
        guard let times = PrayerTimes(coordinates: coordinates, date: day, calculationParameters: params) else {
            return nil
        }
        return DayTimes(times: times)
    }

    /// The next prayer after `now`, rolling over to tomorrow's Fajr after Isha.
    func nextPrayer(after now: Date) -> (salah: Salah, time: Date)? {
        if let today = times(on: now),
           let salah = Salah.allCases.first(where: { today.time($0) > now }) {
            return (salah, today.time(salah))
        }
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now),
              let times = times(on: tomorrow) else { return nil }
        return (.fajr, times.time(.fajr))
    }

    var qiblaDirection: Double {
        Qibla(coordinates: coordinates).direction
    }

    // MARK: Location and compass

    func refreshLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break // Denied: keep using the saved or fallback location.
        }
    }

    func startHeading() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingHeading()
        }
    }

    func stopHeading() {
        manager.stopUpdatingHeading()
        heading = nil
    }

    private func save(latitude: Double, longitude: Double) {
        let store = UserDefaults.standard
        let moved = abs(latitude - store.double(forKey: "lastLatitude")) > 0.05
            || abs(longitude - store.double(forKey: "lastLongitude")) > 0.05
        coordinates = Coordinates(latitude: latitude, longitude: longitude)
        store.set(latitude, forKey: "lastLatitude")
        store.set(longitude, forKey: "lastLongitude")
        if moved {
            Reminders.rescheduleAll(prayers: self)
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in self.refreshLocation() }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        Task { @MainActor in self.save(latitude: latitude, longitude: longitude) }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // No fix (e.g. indoors). The saved location keeps prayer times working.
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let value = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        Task { @MainActor in self.heading = value }
    }
}

struct DayTimes {
    let times: PrayerTimes

    func time(_ salah: Salah) -> Date {
        switch salah {
        case .fajr: times.fajr
        case .dhuhr: times.dhuhr
        case .asr: times.asr
        case .maghrib: times.maghrib
        case .isha: times.isha
        }
    }
}
