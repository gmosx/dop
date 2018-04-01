import Utility

class BumpVersionCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "version-bump", summary: "Bump the version", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        BumpVersionJob(project: project).run()
    }
}
