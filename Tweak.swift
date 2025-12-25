import Foundation

fileprivate func getTimeForOffset(hours: Int, minutes: Int) -> String {
    var dateComponents = DateComponents()
    dateComponents.hour = hours
    dateComponents.minute = minutes

    let calendar = Calendar(identifier: .gregorian)
    if let currentDateWithOffset = calendar.date(byAdding: dateComponents, to: Date()) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: currentDateWithOffset)
    } else {
        return "idk"
    }
}
