import Utility

class PushImageCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "image-push", summary: "Push the image to the registry", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        PushImageJob(project: project).run()
    }
}
