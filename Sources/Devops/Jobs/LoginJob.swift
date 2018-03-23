import Foundation

/// Usage: eval $(dop login)
public final class LoginJob: DevopsJob {
    public override func run() {
        print(
            """
            bx login -u \(project.userName) -p \(project.password.escapingForShell()) -c \(project.accountId) -o \(project.organizationName) -s \(project.spaceName) && bx cr login && bx cs init && eval `bx cs cluster-config \(project.clusterName) --export`
            """
        )
    }
}
