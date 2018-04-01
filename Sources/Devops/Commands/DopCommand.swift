import Foundation
import Basic
import Utility

public class DopCommand: DevopsCLICommand {
    let toolVersion = "0.10.0"

    var versionOption: OptionArgument<Bool>!

    public convenience init(project: Project) {
        self.init(name: "dop", summary: "Support devops workflows", project: project)
    }

    public override func setup() {
        versionOption = argumentParser.add(option: "--version", shortName: "-v", kind: Bool.self, usage: "Show the version")

        add(subcommand: InitCommand(project: project))
        add(subcommand: LoginCommand(project: project))
        add(subcommand: BumpVersionCommand(project: project))
        add(subcommand: BuildImageCommand(project: project))
        add(subcommand: RunImageCommand(project: project))
        add(subcommand: PushImageCommand(project: project))
        add(subcommand: UpgradeReleaseCommand(project: project))
        add(subcommand: CleanCommand(project: project))
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
