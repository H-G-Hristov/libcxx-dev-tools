# How-To Setup ***GitHub*** with ***SSH***

## Sample `~/.ssh/config`

```ini
###############################################################################
# How-To: Setup SSH with GitHub
###############################################################################
# 1. To generate new SSH keys:
#   $ ssh-keygen -t ed25519 -C "<GitHub email address>" -f "<SSH Key filename>"
# 2. To add the key to SSH Agent:
#   $ ssh-add --apple-use-keychain ~/.ssh/<SSH Key filename>
# 3. To copy the public key to the clipboard:
#   $ pbcopy < "<SSH Key filename>.pub"
# 4. To add the SSH public key to GitHub:
#   Go to https://github.com
# 5. Create a user configuration:
#   $ touch ~/.ssh/config
# and add the following:
#   # <<GitHub user name>> GitHub account
#   # To clone:
#   #   $ git clone git@<config name>:<project owner name>/<project name>.git
#   # Configure GiHub user for each directory:
#   #   $ git config user.email "<email address>"
#   #   $ git config user.name "<GitHub user name>"
#   # To add remote `origin` to project:
#   #   $ git remote add origin git@<config name>:<GitHub user name>
#   # Configuration:
#   # Host <config name>
#   #   HostName github.com
#   #   User git
#   #   IdentityFile ~/.ssh/<SSH key filename>
# 6. To configure user:
#   $ git config user.email "<email address>"
#   $ git config user.name "<GitHub user name>"
# 6. To add the SSH authentication to an existing repository:
#   $ git remote set-url origin git@<config name>:<GitHub user name>/<project name>.git
# 7. To clone an new repository:
#   $ git clone git@<config name>:<GitHub user name>/<project name>.git
# 8. To add remote `origin`:
#   $ git remote add origin git@<config name>:<GitHub user name>
# 9. To test the SSH key authentication:
#   $ ssh -T git@<config name>
#
# WARNING: 
#   Make sure to execute the commands in the correct directories, e.g. `~/.ssh` or 
#   repository path.

###############################################################################
# Configurations
###############################################################################

# H-G-Hristov GitHub account
# To clone:
#   $ git clone git@H-G-Hristov:llvm/llvm-project.git
# Configure GiHub user for each directory:
#   $ git config user.email "hristo.goshev.hristov@gmail.com"
#   $ git config user.name "H-G-Hristov"
# To add remote `origin` to project:
#   $ git remote add origin git@H-G-Hristov:H-G-Hristov
# Configuration
  Host GitHub-H-G-Hristov
    HostName github.com
    User git
    IdentityFile ~/.ssh/GitHub@H-G-Hristov

# Zingam GitHub account
# To clone:
#   $ git clone git@Zingam:llvm/llvm-project.git
# Configure GiHub user for each directory:
#   $ git config user.email "zingam@outlook.com"
#   $ git config user.name "Zingam"
# To add remote `origin` to project:
#   $ git remote add origin git@Zingam:Zingam
# Configuration:
  Host GitHub-Zingam
    HostName github.com
    User git
    IdentityFile ~/.ssh/GitHub@Zingam

# Host github.com
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_ed25519
```
