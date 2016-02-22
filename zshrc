# load zgen
source "${HOME}/.dotfiles/zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/heroku
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/autojump
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/rsync
    zgen oh-my-zsh plugins/compleat
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/git-flow
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/emoji
    zgen oh-my-zsh plugins/frontend-search
    zgen oh-my-zsh plugins/gulp
    zgen oh-my-zsh plugins/lol
    zgen oh-my-zsh plugins/nyan
    zgen oh-my-zsh plugins/mvn
    zgen oh-my-zsh plugins/zsh_reload
    zgen oh-my-zsh plugins/history-substring-search
    zgen load fcambus/ansiweather
    zgen load ascii-soup/zsh-url-highlighter url
    zgen load zsh-users/zsh-syntax-highlighting

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/robbyrussell

    # save all to init script
    zgen save
fi

# Handle the fact that this file will be used with multiple OSs
platform=`uname`
if [[ $platform = 'Linux' ]]; then
  alias a='ls -lth --color'
  alias ls='ls --color=auto'
  export EDITOR="vim"
  alias get='sudo apt-get install'
elif [[ $platform = 'Darwin' ]]; then
  alias a='ls -lthG' # sort by date modified
  alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
  export EDITOR='atom-beta'
  alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
  alias flushdns="dscacheutil -flushcache"
fi

# itermocil autocomplete
compctl -g '~/.teamocil/*(:t:r)' itermocil
alias ic='itermocil'

# ruby (irb)
alias irb='irb --readline -r irb/completion'

alias maven='mvn-color'

alias tree='tree --dirsfirst -FC -I "node_modules|.*|*.png|*.jpg|*.gif"'

# Navigation and directory listing
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias q='exit'

# git shortcuts
alias g='git'

alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
# You can use whatever you want as an alias, like for Mondays:
alias FUCK='fuck'
alias please='sudo $(fc -ln -1)'

alias weather='ansiweather'

alias atom='atom-beta'

#npm shortcuts
function ni(){
  npm install $1
}

#bonus shortcuts
alias caf='caffeinate -d'
alias pm='python3 manage.py'

alias gitconfig='$EDITOR ~/.gitconfig'
alias dotfiles="ldot"

function goto(){
  cd $(dirname $(which $1))
}

function pyserver(){
  python -m SimpleHTTPServer $1
}

function phpserver(){
  php -S localhost:$1
}


# =============================
# = Directory save and recall =
# =============================

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    The following aliases (save & show) are for saving frequently used directories
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)
#
#    Make sure to also set the appropriate shell option:
#    zsh:
#      setopt CDABLE_VARS
#    bash:
#      shopt -s cdable_vars

# if ~/.dirs file doesn't exist, create it
if [ ! -f ~/.dirs ]; then
  touch ~/.dirs
fi
# Initialization for the 'save' facility: source the .dirs file
source ~/.dirs

alias show='cat ~/.dirs'
alias showdirs="cat ~/.dirs | ruby -e \"puts STDIN.read.split(10.chr).sort.map{|x| x.gsub(/^(.+)=.+$/, '\\1')}.join(', ')\""

function save (){
  local usage
  usage="Usage: save shortcut_name"
  if [ $# -lt 1 ]; then
    echo "$usage"
    return 1
  fi
  if [ $# -gt 1 ]; then
    echo "Too many arguments!"
    echo "$usage"
    return 1
  fi
  if [ -z $(echo $@ | grep --color=never "^[a-zA-Z]\w*$") ]; then
    echo "Bad argument! $@ is not a valid alias!"
    return 1
  fi
  if [ $(cat ~/.dirs | grep --color=never "^$@=" | wc -l) -gt 0 ]; then
    echo -n "That alias is already set to: "
    echo $(cat ~/.dirs | awk "/^$@=/" | sed "s/^$@=//" | tail -1)
    echo -n "Do you want to overwrite it? (y/n) "
    read answer
    if [ ! "$answer" = "y" -a ! "$answer" = "yes" ]; then
      return 0
    else
      # backup just in case
      cp ~/.dirs ~/.dirs.bak
      # delete existing version(s) of this alias
      cat ~/.dirs | sed "/^$@=.*/d" > ~/.dirs.tmp
      mv ~/.dirs.tmp ~/.dirs
    fi
  fi
  # add a newline to the end of the file if necessary
  if [ $(cat ~/.dirs | sed -n '/.*/p' | wc -l) -gt $(cat ~/.dirs | wc -l) ]; then
    echo >> ~/.dirs
  fi
  echo "$@"=\"`pwd`\" >> ~/.dirs
  source ~/.dirs
  echo "Directory shortcuts:" `showdirs`
}
PATH=$PATH:$HOME/bin

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

prefix=/Users/cshaver/.npmpackages
NPM_PACKAGES=/Users/cshaver/.npm-packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
eval "`npm completion`"

export NVM_DIR="/Users/cshaver/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

source ~/.extras
