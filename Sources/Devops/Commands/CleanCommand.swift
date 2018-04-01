import Utility

class CleanCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "clean", summary: "Remove all generated files", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        PushImageJob(project: project).run()
    }
}
