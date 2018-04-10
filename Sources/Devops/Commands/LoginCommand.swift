import Utility

class LoginCommand: DevopsCommand {
    convenience init() {
        self.init(name: "login", summary: "Connect to IBM Cloud")
    }

    override func run(result: ArgumentParser.Result) {
        print(
            """
            bx login -u \(project.userName) -p \(project.password.escapingForShell()) -c \(project.accountId) -o \(project.organizationName) -s \(project.spaceName) && bx cr login && bx cs init && eval `bx cs cluster-config \(project.clusterName) --export`
            """
        )
    }
}
