import Utility

class RunImageCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "image-run", summary: "Run the image as a local container", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        RunImageJob(project: project).run()
    }
}
