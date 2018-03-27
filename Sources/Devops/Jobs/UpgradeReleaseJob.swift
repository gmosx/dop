import Foundation

public final class UpgradeReleaseJob: DevopsJob {
    public override func run() {
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

