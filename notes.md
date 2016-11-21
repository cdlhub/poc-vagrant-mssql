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
```