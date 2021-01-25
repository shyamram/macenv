
# References:
#https://github.com/nicolashery/mac-dev-setup
#https://opensource.com/article/20/8/iterm2-zsh
#https://github.com/ohmyzsh/ohmyzsh/
#https://github.com/mathiasbynens/dotfiles
# - my fork: https://github.com/shyamram/dotfiles.git
# https://raw.githubusercontent.com/shyamram/pythonwork/master/README.md
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
#https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

# xcode
xcode-select — install

# backup
do_backup() {

	files="\
		.profile \
		.bash_profile \
		.bashrc \
		.bash_prompt  \
		.zshrc \
		.path \
		.extra \
		.gitconfig \
		.gitignore
	"

	mkdir -p ~/backups/dotfiles
	#dt="$(date '+d')"
	dt="$(date '+%Y%m%d-%H%M')"
	for file in $files
	do
		cp -p ~/$file ~/backups/dotfiles/$file.bkup.$dt 
	done
		

}

do_backup


# homebrew

sh -c "$(curl -fsSL --output homebrew_installer.sh https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
bash homebrew_installer.sh
# xcode-select -r  # incase of error - to cleanup

# brew usage

echo 'Brew usage:
	brew install <formulae>
	brew outdated
	brew upgrade <formula>
	brew cleanup		# delete older versions
	brew list --versions
'

# git
brew install git

curl -output ~/.gitconfig  https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.gitconfig
curl -output ~/.gitignore  https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.gitignore

echo '
git config --global user.name "Shyam Sunder Ramamoorthy"
git config --global user.email "samdoode@gmail.com"
git config --global core.excludesfile ~/.gitignore

' >> ~/.gitconfig


# dotfiles

#git clone https://github.com/mathiasbynens/dotfiles.git && cd dotfiles && source bootstrap.sh

git clone https://github.com/shyamram/dotfiles.git && 
  cd dotfiles && 
  source bootstrap.sh

# ~/.path
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.path

# ~/.extra
echo '
# You could use ~/.extra to override settings, functions and aliases from my dotfiles repository.
# Git credentials
GIT_AUTHOR_NAME="Mathias Bynens"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="mathias@mailinator.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
' >> ~/.extra

# new MacOS defaults

./.macos


# install some common Homebrew formulae on a new mac
./brew.sh

# iterm2
brew cask install iterm2

# zsh
brew install zsh

# change default shell to zsh
chsh -s $(which zsh)


# beautiful terminal

cd ~

cd ~/Downloads
curl -o "Atom One Dark.itermcolors" https://raw.githubusercontent.com/nathanbuchar/atom-one-dark-terminal/master/scheme/iterm/One%20Dark.itermcolors
curl -o "Atom One Light.itermcolors" https://raw.githubusercontent.com/nathanbuchar/atom-one-dark-terminal/master/scheme/iterm/One%20Light.itermcolors

curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_profile
curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_prompt
curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.aliases



# Oh My zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo '
plugins=(
  git
  gitignore
  dotenv
  osx
  zsh-syntax-highlighting
  zsh-autosuggestions
)
' >> ~/.zshrc

#zsh omz_installer.sh
zsh --version
upgrade_oh_my_zsh

# zsh theme - Powerlevel 10k - p10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
source ~/.zshrc

# other zsh theme
#ZSH_THEME="agnoster" # (this is one of the fancy ones)
# see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster


# p10k configure
p10k configure  # this should run automatically after your source .zshrc

# dracula color scheme
git clone https://github.com/dracula/iterm.git
echo "Manually Update iterm2 preferences"
echo '
Navigate to iTerm2 > Preferences > Profiles > Colors.
Open the Color Presets drop-down in the bottom-right corner.
Select Import from the list.
Select the Dracula.itermcolors file.
Select Dracula from Color Presets.
'


# fonts
# p10k fonts
git clone https://github.com/powerline/fonts

# meslo-nerd-font
echo "TODO: git link doesn't work - download the font files and double-click to install them"
git clone https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

# install font
echo "Install font: iTerm2 > Preferences > Profiles > Text and set Font to MesloLGS NF"

# plugin zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
	${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo 'plugins=( git zsh-syntax-highlighting zsh-autosuggestions)' >> ~/.zshrc
source ~/.zshrc


# vim settings

mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/sensible.git
cd -


# pyenv - manage multiple versions of python

brew install pyenv
echo 'if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi' > ~/.zshrc
source ~/.zshrc

brew install openssl readline sqlite3 xz zlib	# dependencies for pyenv
pyenv install --list	# list all available python versions

echo 'pyenv commands - eg.
pyenv install 3.x.x
pyenv versions
pyenv shell 3.x.x	# switch python version
phython --version
pyenv local 3.x.x	# save project's python version .python-version
'

echo 'pip commands - eg.
pip install <package>
pip install --upgrade <package>
pip freeze  # what's installed
pip uninstall <package>
'

# virtualenv - virtualenv is a tool that creates an isolated Python environment for each of your projects.

# For a particular project, instead of installing required packages globally, it is best to install them in an isolated folder, 
# that will be managed by virtualenv. The advantage is that different projects might require different versions of packages, 
# and it would be hard to manage that if you install packages globally.
# Instead of installing and using virtualenv directly, we'll use the dedicated pyenv plugin pyenv-virtualenv 
# which will make things a bit easier for us. 


brew install pyenv-virtualenv

echo 'if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >> ~/.zshrc
source ~/.zshrc

echo 'pyenv usage. eg. 
pyenv virtualenv 3.7.5 myproject	#  create a virtualenv called myproject with python version 3.7.5
pyenv virtualenvs 	# list of virtualenvs created
pyenv active myproject	# activate your virtualenv environment
pyenv local myproject	# set your projects .python-version to point to a virtualenv you have created
source deactivate  # to deactivate your current python environment
'

# Java
brew cask install homebrew/cask-versions/java8

# other software
brew install postgresql
#brew services start postgresql

brew install redis
#brew services start redis

echo 'Other apps to install..'
echo 'Postman GitHub Desktop'

# set up GPG key for Git signed commits
# https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-gpg-key

echo "If you are on version 2.1.17 or greater"
echo "Keytype: RSA, Keysize: 4096,  KeyExpiry:<default - no expire>""
echo "Userid: <github email>, secure passphrase"
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG
echo "copy the GPG key ID "
echo "gpg --armor --export <gpg keyid>"
echo 'Copy your GPG key, beginning with -----BEGIN PGP PUBLIC KEY BLOCK----- and ending with -----END PGP PUBLIC KEY BLOCK-----'
echo 'Add the GPG key to your GitHub account Profile -> Settings -> SSH & GPG key -> New GPG key -> Paste your GPG key'
echo "Update your .gitconfig file"
echo 'git config --global user.signingkey <gpg keyid>'
echo 'signingkey = 1E0EC299B0896834' >> ~/.gitconfig
echo "echo 'export GPG_TTY=$(tty)' >> ~/.bash_profile or ~/.zhsrc"
echo 'git config --global commit.gpgsign true'
brew cask install gpg-suite-no-mail gpg-suite-pinentry
echo '
You may need to set "pinentry-program" in ~/.gnupg/gpg-agent.conf as follows:
  pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac
'
echo 'export GPG_TTY=$(tty)' >> ~/.zhsrc
echo 'pinentry-program /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac' >> ~/.gnupg/gpg-agent.conf
git config --global commit.gpgsign true


echo '
To configure your Git client to sign commits by default for a local repository, in Git versions 2.0.0 and above, 
run 
git config commit.gpgsign true. 
To sign all commits by default in any local repository on your computer, run 
git config --global commit.gpgsign true.
To store your GPG key passphrase so you don't have to enter it every time you sign a commit, we recommend using the following tools:
For Mac users, the GPG Suite allows you to store your GPG key passphrase in the Mac OS Keychain.
'

# git secrets
# https://github.com/awslabs/git-secrets#homebrew-for-macos-users
brew install git-secrets
git secrets --register-aws --global




# docker
brew cask install docker

# virtualbox
brew cask install virtualbox virtualbox-extension-pack

# terraform -  https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -install-autocomplete

# kuberbetes
#brew install mini-kube kind k9s
brew install kind k9s

# go
brew install go


# IDE - visual studio gui
brew cask install visual-studio-code
brew cask install intellij-idea

# browsers
brew install google-chrome firefox

# aws cli
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# okta - https://github.com/segmentio/aws-okta
brew install aws-okta

# API
brew cask install postman

echo "Restart Terminal and Enjoy!"

###

