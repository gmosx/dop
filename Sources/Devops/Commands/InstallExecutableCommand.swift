import Utility

// TODO: consider option to bump the version 
// TODO: allow for `ln -sf` or `cp` 
// ln -sf `pwd`/.build/release/\(project.executableName) /usr/local/bin/\(project.executableName)

class InstallExecutableCommand: DevopsCommand {
    convenience init() {
        self.init(name: "executable-install", summary: "Install the executable to an in-path directory")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute(script:
                """
                swift build -c release
                cp .build/release/\(project.executableName) /usr/local/bin/\(project.executableName)
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
