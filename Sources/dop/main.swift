import Foundation
import Basic
import Utility
import Devops

let toolVersion = "0.10.0"

// https://www.hackingwithswift.com/articles/44/apple-s-new-utility-library-will-power-up-command-line-apps

class DevopsCLICommand: CLICommand {
    let project: Project
    let shell: Devops.Shell

    init(name: String, summary: String, usage: String? = nil, project: Project) {
        self.project = project
        self.shell = Devops.Shell()
        super.init(name: name, summary: summary, usage: usage)
    }
}

class DopCommand: DevopsCLICommand {
    var versionOption: OptionArgument<Bool>!

    convenience init(project: Project) {
        self.init(name: "dop", summary: "Support devops workflows", project: project)
    }

    override func setup(argumentParser: ArgumentParser) {
        super.setup(argumentParser: argumentParser)

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

    override func run(result: ArgumentParser.Result) {
        if let _ = result.get(versionOption) {
            print("Version \(toolVersion)")
        } else {
            argumentParser.printUsage(on: stdoutStream)
        }
    }
}

class InitCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "init", summary: "Initialize the package for managegement", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        InitJob(project: project).run()
    }
}

class LoginCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "login", summary: "Connect to IBM Cloud", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        LoginJob(project: project).run()
    }
}

class BumpVersionCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "version-bump", summary: "Bump the version", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        BumpVersionJob(project: project).run()
    }
}

class BuildImageCommand: DevopsCLICommand {
    var bumpOption: OptionArgument<Bool>!

    convenience init(project: Project) {
        self.init(name: "image-build", summary: "Build the container image", project: project)
    }

    override func setup(argumentParser: ArgumentParser) {
        super.setup(argumentParser: argumentParser)

        bumpOption = argumentParser.add(option: "--bump", shortName: "-b", kind: Bool.self, usage: "Bump version before building image")
    }

    override func run(result: ArgumentParser.Result) {
        BuildImageJob(project: project).run()
    }
}

class RunImageCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "image-run", summary: "Run the image as a local container", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        RunImageJob(project: project).run()
    }
}

class PushImageCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "image-push", summary: "Push the image to the registry", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        PushImageJob(project: project).run()
    }
}

class UpgradeReleaseCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "release-upgrade", summary: "Upgrade a release", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        UpgradeReleaseJob(project: project).run()
    }
}

class CleanCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "clean", summary: "Remove all generated files", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        PushImageJob(project: project).run()
    }
}

final class DopCLITool {
    func run() {
        do {
            let project = try Project(from: URL(fileURLWithPath: "dop.json"))
            let cli = CLI(command: DopCommand(project: project))
            try cli.parse()
        } catch let error as ArgumentParserError {
            print(error.description)
        } catch {
            print(error.localizedDescription)
        }
    }
}

let tool = DopCLITool()
tool.run()
