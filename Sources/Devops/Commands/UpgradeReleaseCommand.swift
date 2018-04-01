import Utility

class UpgradeReleaseCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "release-upgrade", summary: "Upgrade a release", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        UpgradeReleaseJob(project: project).run()
    }
}
