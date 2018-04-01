import Utility

class BuildImageCommand: DevopsCLICommand {
    var bumpOption: OptionArgument<Bool>!

    convenience init(project: Project) {
        self.init(name: "image-build", summary: "Build the container image", project: project)
    }

    override func setup() {
        bumpOption = argumentParser.add(option: "--bump", shortName: "-b", kind: Bool.self, usage: "Bump version before building image")
    }

    override func run(result: ArgumentParser.Result) {
        BuildImageJob(project: project).run()
    }
}
