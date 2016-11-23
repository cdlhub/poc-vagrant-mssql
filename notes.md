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

Connect to SQL Server from the VM:

```sh
sqlcmd -S localhost -U SA -P 'sa_pa$$w0rd'
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

Attach a database:

```sql
CREATE DATABASE DatabaseName
    ON (FILENAME = 'FilePath\FileName.mdf'), -- Main Data File .mdf
    (FILENAME = 'FilePath\LogFileName.ldf') -- Log file .ldf
    FOR ATTACH;
GO
```

## Solution

1. Shared folder does not work with DB file (neither MS SQL Server nor PostgreSQL) when switching host system (Windows, MacOS, ...).
2. The DB file (mdf) needs to be inside Vagrant box =>
    1. copy mdf from prod DB to a Vagrant shared folder.
    2. Inside Vagrant box, copy mdf file from shared folder to MS SQL Server database file location.
    3. change owner / group to `mssql`.
    4. Attach DB files to server using `sqlcmd`.

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

# Delete a vagrant box (and all its files in .vagrant.d/boxes)
varant box remove <box-name>

# Create a package from a running box
vagrant package --output <box-name>.box

# Add a package to boxes
vagrant box add --name <name> <box-name>.box
```
