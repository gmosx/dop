import Utility

// TODO: consider CLIHandler?
// TODO: subsume CLI into CLICommand?

public class CLIRouter {
    internal let command: CLICommand

    public init(command: CLICommand) {
        let argumentParser = ArgumentParser(usage: command.usage ?? "subcommand <options>", overview: command.summary)
        command.setup(argumentParser: argumentParser)
        command.setup()
        self.command = command
    }

    public var argumentParser: ArgumentParser {
        return command.argumentParser
    }

    public func route(arguments: [String]? = nil) throws {
        let result = try argumentParser.parse(arguments ?? Array(CommandLine.arguments.dropFirst()))

        if let subcommandName = result.subparser(argumentParser) {
            if let subcommand = command.subcommands[subcommandName] {
                subcommand.run(result: result)
            } else {
                print("Unrecognized command '\(subcommandName)'")
            }
        } else {
            command.run(result: result)
        }
    }
}

open class CLICommand {
    public let name: String
    public let summary: String
    public let usage: String?
    public private(set) var argumentParser: ArgumentParser!
    public private(set) var subcommands: [String: CLICommand]

    public init(name: String, summary: String, usage: String? = nil) {
        self.name = name
        self.summary = summary
        self.usage = usage
        self.subcommands = [:]
    }

    public func setup(argumentParser: ArgumentParser) {
        self.argumentParser = argumentParser
    }

    /// Override this method to setup options, flags, subcommands, etc.
    open func setup() {
        return
    }

    public func add(subcommand: CLICommand) {
        let subparser = argumentParser.add(subparser: subcommand.name, overview: subcommand.summary)
        subcommand.setup(argumentParser: subparser)
        subcommand.setup()
        subcommands[subcommand.name] = subcommand
    }

    open func run(result: ArgumentParser.Result) {
    }
}
