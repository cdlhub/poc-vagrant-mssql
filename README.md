# poc-vagrant-mssql

Proof of Concept to install MS SQL Server in a Vagrant Linux box

## Installation

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
- [Vagrant](https://www.vagrantup.com/downloads.html).
- [VB Guest Vagrant plug-in](https://github.com/dotless-de/vagrant-vbguest) in order to update _Guest additions_ automatically.

    ```sh
    vagrant plugin install vagrant-vbguest
    ```

**Note**: Vagrant boxes are located in `~/.vagrant.d/boxes/` (Linux) or `C:\Users\<your-login>\.vagrant.d\boxes\` (Windows).

### Troubleshooting

If `vagrant up` cannot download box, it may be because of embedded `curl`.


```
The box 'hashicorp/precise64' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/hashicorp/precise64"]
Error:
```

**Solution**: Delete embedded `curl`:

- MacOS: `sudo rm -rf /opt/vagrant/embedded/bin/curl`
- Windows:
