# install tools on jumpbox
- azure cli - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
- Kubectl 

        Open a terminal.

        Download the latest version of kubectl:

        bash
        Copy code
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        Make the downloaded binary executable:

        bash
        Copy code
        chmod +x kubectl
        Move the binary to a directory included in your PATH. For example, move it to /usr/local/bin:

        bash
        Copy code
        sudo mv kubectl /usr/local/bin/
        Verify the Installation
        Check the installed version of kubectl:

        bash
        Copy code
        kubectl version --client


