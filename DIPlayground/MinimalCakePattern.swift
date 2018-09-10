import Foundation


protocol UsesClock {
    var clock: ClockProtocol { get }
}


protocol UsesLogger {
    var logger: LoggerProtocol { get }
}


protocol TimeSensitiveFileReaderMCP: UsesClock, UsesLogger {
    func read(fileName: String) -> (Date, String)
}


extension TimeSensitiveFileReaderMCP {
    func read(fileName: String) -> (Date, String) {
        self.logger.info(fileName)
        let now = self.clock.now()
        let fileContent = "DUMMY"
        return (now, fileContent)
    }
}


protocol UsesTimeSensitiveFileReader {
    var fileReader: TimeSensitiveFileReaderMCP { get }
}


protocol TimeSensitiveFilePrinterMCP: UsesTimeSensitiveFileReader {
    func print(fileName: String)
}


extension TimeSensitiveFilePrinterMCP {
    func print(fileName: String) {
        let (date, fileContent) = self.fileReader.read(fileName: fileName)
        Swift.print("\(date): \(fileContent)")
    }
}


protocol TimeSensitiveFilePrinterBad: UsesTimeSensitiveFileReader {
    func print(fileName: String)
}


extension TimeSensitiveFilePrinterBad {
    func print(fileName: String) {
        let (_, fileContent) = self.fileReader.read(fileName: fileName)
        let date = self.fileReader.clock.now()  // BAD: デメテルの法則違反だが、コンパイルエラーにならない
        Swift.print("\(date): \(fileContent)")
    }
}


enum MinimalCakePattern {
    class TimeSensitiveFileReader: TimeSensitiveFileReaderMCP {
        let clock: ClockProtocol = Clock()
        let logger: LoggerProtocol = Logger()
    }


    class TimeSensitiveFileReaderStub: TimeSensitiveFileReaderMCP {
        let clock: ClockProtocol = ClockStub(willReturn: date(from: "2016-06-18")!)
        let logger: LoggerProtocol = LoggerSpy()
    }


    class TimeSensitiveFilePrinter: TimeSensitiveFilePrinterMCP {
        let fileReader: TimeSensitiveFileReaderMCP = TimeSensitiveFileReader()
    }


    class TimeSensitiveFilePrinterSpy: TimeSensitiveFilePrinterMCP {
        let fileReader: TimeSensitiveFileReaderMCP = TimeSensitiveFileReaderStub()
    }
}
