import Utility

// TODO: consider option to bump the version 

class InstallExecutableCommand: DevopsCommand {
    var symbolicLinkOption: OptionArgument<Bool>!

    convenience init() {
        self.init(name: "executable-install", summary: "Install the executable to an in-path directory")
    }

    override func setup() {
        symbolicLinkOption = argumentParser.add(option: "--link", shortName: "-l", kind: Bool.self, usage: "Use symbolic link")
    }

    override func run(result: ArgumentParser.Result) {
        let shouldUseSymbolicLink = result.get(symbolicLinkOption) ?? false
        let shellCommand = shouldUseSymbolicLink ? "ln -sf" : "cp -f"

        do {
            try shell.execute(script:
                """
                swift build -c release
                \(shellCommand) \(shell.currentDirectoryPath)/.build/release/\(project.executableName) /usr/local/bin/\(project.executableName)
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
