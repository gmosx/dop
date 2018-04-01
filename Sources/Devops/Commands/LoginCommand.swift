import Utility

class LoginCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "login", summary: "Connect to IBM Cloud", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        LoginJob(project: project).run()
    }
}
