protocol ClockProtocol {
    func now() -> Date
}


class Clock: ClockProtocol {
    func now() -> Date {
        return Date()
    }
}


class ClockStub: ClockProtocol {
    var date: Date


    init(willReturn date: Date) {
        self.date = date
    }


    func now() -> Date {
        return self.date
    }
}


protocol LoggerProtocol {
    func info(_ message: String)
}


class Logger: LoggerProtocol {
    func info(_ message: String) {
        print(message)
    }
}


class LoggerSpy: LoggerProtocol {
    enum CallArgs: Equatable {
        case info(message: String)
    }


    private(set) var callArgs = [CallArgs]()


    func info(_ message: String) {
        self.callArgs.append(.info(message: message))
    }
}


protocol TimeSensitiveFileReaderProtocol {
    func read(fileName: String) -> (Date, String)
}


protocol TimeSensitiveFilePrinterProtocol {
    func print(fileName: String)
}


func date(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    return formatter.date(from: "2016-06-18")
}
