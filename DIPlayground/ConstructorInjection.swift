enum ConstructorInjection {
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
