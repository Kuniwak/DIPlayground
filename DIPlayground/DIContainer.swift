import Swinject


let defaultContainer = { () -> Container in
    let container = Container()
    container.register(ClockProtocol.self) { _ in Clock() }
    container.register(LoggerProtocol.self) { _ in Logger() }
    container.register(TimeSensitiveFileReaderProtocol.self) { resolver in
        let clock = resolver.resolve(ClockProtocol.self)!
        let logger = resolver.resolve(LoggerProtocol.self)!
        return DIContainer.TimeSensitiveFileReader(clock: clock, logger: logger)
    }
    container.register(TimeSensitiveFilePrinterProtocol.self) { resolver in
        let fileReader = resolver.resolve(TimeSensitiveFileReaderProtocol.self)!
        return DIContainer.TimeSensitiveFilePrinter(fileReader: fileReader)
    }
    return container
}()


enum DIContainer {
    class TimeSensitiveFileReader: TimeSensitiveFileReaderProtocol {
        private let clock: ClockProtocol
        private let logger: LoggerProtocol

        init(clock: ClockProtocol, logger: LoggerProtocol) {
            self.clock = clock
            self.logger = logger
        }


        func read(fileName: String) -> (Date, String) {
            self.logger.info(fileName)
            let now = self.clock.now()
            let fileContent = "DUMMY"
            return (now, fileContent)
        }
    }


    class TimeSensitiveFilePrinter: TimeSensitiveFilePrinterProtocol {
        private let fileReader: TimeSensitiveFileReaderProtocol


        init(fileReader: TimeSensitiveFileReaderProtocol) {
            self.fileReader = fileReader
        }


        func print(fileName: String) {
            let (date, fileContent) = self.fileReader.read(fileName: fileName)
            Swift.print("\(date): \(fileContent)")
        }
    }


    class TimeSensitiveFilePrinterBad: TimeSensitiveFilePrinterProtocol {
        private let fileReader: TimeSensitiveFileReaderProtocol


        init(fileReader: TimeSensitiveFileReaderProtocol) {
            self.fileReader = fileReader
        }


        func print(fileName: String) {
            // GOOD: デメテルの法則違反はコンパイルエラーになる
            // let (_, fileContent) = self.fileReader.read(fileName: fileName)
            // date = self.fileReader.clock.now()
            // Swift.print("\(date): \(fileContent)")
        }
    }
}
