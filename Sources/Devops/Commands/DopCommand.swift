import Foundation
import Basic
import Utility
import CLIHandler

public class DopCommand: CLICommand {
    let toolVersion = "0.11.0"

    var versionOption: OptionArgument<Bool>!

    public convenience init() {
        self.init(name: "dop", summary: "Support devops workflows")
    }

    public override func setup() {
        versionOption = argumentParser.add(option: "--version", shortName: "-v", kind: Bool.self, usage: "Show the version")

        add(subcommand: InitCommand())
        add(subcommand: LoginCommand())
        add(subcommand: BuildToolsImageCommand())
        add(subcommand: BumpVersionCommand())
        add(subcommand: BuildImageCommand())
        add(subcommand: RunImageCommand())
        add(subcommand: RegisterImageCommand())
        add(subcommand: UnregisterImageCommand())
        add(subcommand: UpgradeReleaseCommand())
        add(subcommand: ContainerLogsCommand())
        add(subcommand: CleanCommand())
    }

    public override func run(result: ArgumentParser.Result) {
        if let _ = result.get(versionOption) {
            showVersion()
        } else {
            showUsage()
        }
    }

    func showVersion() {
        print("Version \(toolVersion)")
    }

    func showUsage() {
        argumentParser.printUsage(on: stdoutStream)
    }
}
