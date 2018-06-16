import Utility

class UpgradeReleaseCommand: DevopsCommand {
    convenience init() {
        self.init(name: "release-upgrade", summary: "Apply a deployment to the Kubernetes cluster")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute(script:
                """
                helm template \(project.chartPath) > deployment.yaml
                kubectl apply -f deployment.yaml
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
