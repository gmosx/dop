import Utility

class UpgradeReleaseCommand: DevopsCommand {
    convenience init() {
        self.init(name: "release-upgrade", summary: "Upgrade a release")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute(script:
                """
                helm template chart/\(project.name)
                kubectl apply -f deployment.yaml
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
