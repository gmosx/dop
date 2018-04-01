import Utility

class InitCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "init", summary: "Initialize the package for managegement", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        InitJob(project: project).run()
    }
}
