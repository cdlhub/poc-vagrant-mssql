## Installation

Use CentOS 7:

```sh
vagrant box add centos/7
```

Set VM RAM to at least 4096MB (within VirtualBox manager).

Follow [Install SQL Server on Red Hat Enterprise Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-red-hat) to install _MS SQL Server_ on CentOS.

```sh
vagrant init centos/7
vagrant up
vagrant ssh

# Then install MS SQL Server
...
```

Set SA password to `sa_pa$$w0rd`.

Check MS SQL service is running:

```sh
systemctl status mssql-server
```

Create database on host file system:

```sql
use [master];
go

create database [test1] on primary
( NAME = N'test1_data', FILENAME = N'/vagrant_data/test1.mdf')
log on
( NAME = N'test1_log', FILENAME = N'/vagrant_data/test1.ldf')
go
```

## Provisioning

I chose Ansible because it seems to be the simplest of the three provisioning tools (Chef, Puppet, and Ansible)

## Commands

```sh
# Initialize a project folder for vagrant use
vagrant init

# Add a box to vagrant folder
vagrant box add <box>

# Initialize and add a box in one step
vagrant init <box>

# Start the VM
vagrant up

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
```
