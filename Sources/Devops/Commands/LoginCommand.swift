import Utility

class LoginCommand: DevopsCLICommand {
    convenience init(project: Project) {
        self.init(name: "login", summary: "Connect to IBM Cloud", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        print(
            """
            bx login -u \(project.userName) -p \(project.password.escapingForShell()) -c \(project.accountId) -o \(project.organizationName) -s \(project.spaceName) && bx cr login && bx cs init && eval `bx cs cluster-config \(project.clusterName) --export`
            """
        )
    }
}
