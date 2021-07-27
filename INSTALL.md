# Poland iOS - INSTALL.md

#### References


* Core repository - [INSTALL.md](https://github.com/santander-group-europe/ios-santander-one/blob/master/INSTALL.md)
* Spain repository - [INSTALL.md](https://github.com/santander-group-europe/ios-spain/blob/master/INSTALL.md)
* Portugal repository - [INSTALL.md](https://github.com/santander-group-europe/ios-portugal/blob/master/INSTALL.md)
 

#### Clone Source Code

 

Generate SSH key pair with the next command 


```bash
$ ssh-keygen -t rsa

```
    
Upload generated public key to [GitHub Keys](https://github.com/settings/keys)


[GitHub Documentation](https://docs.github.com/es/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)


And finally clone project and submodules:

```bash
$ git clone --recurse-submodules --remote-submodules git@github.com:santander-group-europe/ios-poland.git
pod install
```
Open the generated workspace.
