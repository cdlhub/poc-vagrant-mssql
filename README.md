# Proof of Concept - MS SQL Server on Vagrant Linux box

<!-- TOC START min:2 max:4 link:true update:true -->
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Start MS SQL Server](#start-ms-sql-server)
  - [Troubleshooting](#troubleshooting)
    - [Cannot download box](#cannot-download-box)
    - [Hyper-V and VirtualBox incompatibility](#hyper-v-and-virtualbox-incompatibility)
  - [Project's record of work](#projects-record-of-work)
  - [Vagrant commands](#vagrant-commands)

<!-- TOC END -->

## Introduction

The objective of this project is to be able to encapsulate MS SQL Server installation in a box to facilitate the creation of development, staging, and production environments. Another advanage is to be able to run the server on any host system (Windows, MacOS, Linux).

**Remark:** [MS SQL on Linux on Docker](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-docker) could also be a good choice. However, it has been rejected for now because:

1. Docker for Windows is only available for Windows 10 Pro.
2. Volume functionality for MS SQL Server on Linux does not run on all host systems.

## Installation

- Download [VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your system and follow instruction to install it.
- Download [Vagrant](https://www.vagrantup.com/downloads.html) for your system and follow instruction to install it.
- Install [VB Guest Vagrant plug-in](https://github.com/dotless-de/vagrant-vbguest) in order to update _VitrualBox Guest additions_ automatically. After VirtualBox is installed, use a console to type:

    ```sh
    vagrant plugin install vagrant-vbguest
    ```
- Download [Git for Windows](https://git-scm.com/download/) to let Vagrant use SSH command on Windows Console (this is not needed on systems that have _ssh_ installed by defulat like Linux and MacOS).
- Install MS SQL tools on your host:
    - Windows:  [SSMS](https://msdn.microsoft.com/en-us/library/mt238290.aspx).
    - Linux: [SQL Server tools](https://docs.microsoft.com/fr-fr/sql/linux/sql-server-linux-setup-tools).
    - MacOS: [sql-cli](https://www.npmjs.com/package/sql-cli).
    - Visual Studio Code (any platforms): [mssql extension](https://github.com/Microsoft/vscode-mssql#mssql-for-visual-studio-code).
- Turn off Hyper-V feature on Windows:

    ![Turn off Hyper-V feature](img/turn-off-hyper-v-feature.png)

## Start MS SQL Server

- Clone this repository.
- Start the virtual machine from the repository folder (this may take some time the first time you perform this operation):

    ```sh
    vagrant up
    ```

See [Vagrant commands](#vagrant-commands) for a comprehensive list of commands in order to manage boxes and VM.

You can now access MS SQL Server using [SQL Server tools](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools) (MacOS, Linux) or [SSMS](https://msdn.microsoft.com/en-us/library/hh213248.aspx) (Windows):

- Server address: `192.168.33.10`
- Port: `1433` (default MS SQL Server port)
- User: `SA`
- Password: `sa_pa$$w0rd`

You can use `sqlcmd` tool to enter interactive T-SQL:

```sh
sqlcmd -S 192.168.33.10 -U SA -P 'sa_pa$$w0rd'
```

**Note**: Vagrant boxes are located in `~/.vagrant.d/boxes/` (Linux) or `C:\Users\<your-login>\.vagrant.d\boxes\` (Windows).

## Troubleshooting

### Cannot download box

**Error:**

```
The box 'hashicorp/precise64' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/hashicorp/precise64"]
Error:
```

If `vagrant up` cannot download box, it may be because of embedded `curl`. In that case you need to delete embedded `curl`:

- MacOS: `sudo rm -rf /opt/vagrant/embedded/bin/curl`

This error has also been reported on Windows (search a solution on StackOverflow if it arises).

### Hyper-V and VirtualBox incompatibility

**Error:**

```
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["startvm", "3dcac5fa-93aa-44fc-8594-851884e9b269", "--type", "headless"]

Stderr: VBoxManage.exe: error: VT-x is not available (VERR_VMX_NO_VMX)
VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole
```

Hyper-V and VirtualBox cannot run together. Hyper-V needs to be turned off. See [Installation steps](#installation).

## Project's record of work

- Create a git repository for the project:

    ```sh
    mkdir poc-vagrant-mssql
    cd poc-vagrant-mssql
    git init
    ```
- Add vagrant metadata to `.gitignore`:

    ```sh
    # Vagrant metadata
    .vagrant/

    # Do not track packaged box
    *.box
    ```
- We chose CentOS as a guest system because Microsoft packages MS SQL for Linux for Red Hat Enterprise Linux (RHEL):

    ```sh
    vagrant init centos/7
    ```
- Configure [`Vagrantfile`](Vagrantfile).
    - Change VM IP address to avoid conlict if needed.
    - MS SQL Server on Linux needs at least 4MB of RAM.

    ```ruby
    Vagrant.configure("2") do |config|
      config.vm.box = "centos/7"

      # Provision the VM using a shell script
      config.vm.provision "shell", path: "provision.sh"

      # Create a forwarded port from host machine
      config.vm.network "forwarded_port", guest: 1433, host: 14333

      # Set private network IP and VM hostname
      config.vm.network "private_network", ip: "192.168.33.10"
      config.vm.hostname = "mssqlserver"

      # Example for VirtualBox configuration
      config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = false
        # Customize the amount of memory on the VM:
        vb.name = "MS-SQL-Server"
        vb.memory = "4096"
        vb.cpus = 2
      end
    end
    ```
- Set [provision script](provision.sh) following [Install SQL Server on Red Hat Enterprise Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-red-hat). Make sure that `--enable-service` is set for command `/opt/mssql/bin/sqlservr-setup` in order to start MS SQL Server service at boot time. It will also create database `product_db` with one `inventory` empty table using [`create_db.sql`](scripts/create_db.sql).
- Start the VM to provision it:

    ```sh
    vagrant up
    ```
- Open a SSH session and check MS SQL service is running:

    ```sh
    vagrant ssh
    [vagrant@mssqlserver ~]$ systemctl status mssql-server
    ● mssql-server.service - Microsoft(R) SQL Server(R) Database Engine
       Loaded: loaded (/usr/lib/systemd/system/mssql-server.service; disabled; vendor preset: disabled)
       Active: active (running) since jeu 2016-11-24 16:05:55 UTC; 42min ago
     Main PID: 26402 (sqlservr)
       CGroup: /system.slice/mssql-server.service
               ├─26402 /opt/mssql/bin/sqlservr
               └─26413 /opt/mssql/bin/sqlservr
   [vagrant@mssqlserver ~]$ exit
    ```
- Run _SSMS_ (Windows), `sqlcmd` (Linux), or `sql-cli`(MacOS) from the host machine to access VM. Simple scripts are provided in [`scripts/`](scripts) folder:

    ```sh
    # sqlcmd
    sqlcmd -S 192.168.33.10 -U SA -P 'sa_pa$$w0rd' -i scripts/insert-data.sqlcmd

    # sql-cli
    mssql -s 192.168.33.10 -u SA -p 'sa_pa$$w0rd'
    ```

## Vagrant commands

```sh
# Initialize a project folder for vagrant use
vagrant init

# Add a box to vagrant folder
vagrant box add <box>

# Initialize and add a box in one step
# It creates the Vagrant file for the box
vagrant init <box>

# Start the VM
vagrant up

# Provision again a running box
vagrant provision

# Shutdown VM
vagrant halt

# Suspend VM
vagrant suspend

# Perform halt and up in one command
vagrant reload

# Completely remove VM from VirtualBox
vagrant destroy

# Display the state of the underlying guest machine.
vagrant status

# List install boxes
vagrant box list

# Remove box files
vagrant box remove <name>

# Update boxes
vagrant box update

# Create a package from a running box
vagrant package --output <box-name>.box

# Add a package to boxes
vagrant box add --name <name> <box-name>.box
```
