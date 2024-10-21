eval "$(oh-my-posh init bash --config $HOME/.config/oh-my-posh/zen.toml)"

source ~/.git-plugin-bash.sh

# aws login
alias awslogin="aws configure sso --profile default"

# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#
lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}

bind '"\C-o":"lfcd\C-m"'

aws sts get-caller-identity &> /dev/null
if [ $? -ne 0 ]; then
    aws sso login
fi

alias sam="/c/Program\ Files/Amazon/AWSSAMCLI/bin/sam.cmd"
