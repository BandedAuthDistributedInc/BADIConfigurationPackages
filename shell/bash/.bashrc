#!/bin/bash
## .bashrc #####################
# Wintervenom [(at)] gmail.com #
################################

. /etc/profile

export BROWSER='elinks'
[[ ! $PATH =~ "$HOME/node_modules/.bin" ]] &&
    export PATH="$HOME/node_modules/.bin:$PATH"
[[ ! $PATH =~ "$HOME/Application/Scripts" ]] &&
    export PATH="$HOME/Application/Scripts:$PATH"
[[ ! $PATH =~ '/opt/android-sdk/platform-tools' ]] &&
    export PATH="$PATH:/opt/android-sdk/platform-tools"
export XDG_DESKTOP_DIR=$HOME
export XDG_CONFIG_HOME="$HOME/.config"
export SSH_ENV="$HOME/.ssh/environment"
export GEGL_USE_OPENCL='yes'
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export REMINDERS="$HOME/Application/Settings/reminders.txt"

### NON-INTERACTIVE MODE ###
[[ $- != *i* ]] && return

### INTERACTIVE MODE ###
title "$HOSTNAME: Setting up environment..."


#####################
### Shell Options ###
#####################
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s expand_aliases
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s dotglob


#############################
### Environment Variables ###
#############################
export HISTCONTROL=erasedups

export EDITOR='vim'
export PAGER='less -r'
export WWW_HOME='http://www.google.com'

export DMENU_OPTIONS='-nb white -nf black -sb #AAAAAA -sf white'
export WINEDEBUG='-all'
export GEGL_USE_OPENCL='yes'

export abs_dir="$HOME/Packages/abs"



##############
### Colors ###
##############
export color_N=$(tput sgr0)                 # Normal
export color_F=$(tput blink)                # Blink

### Standard text ###
export color_L=$(tput sgr0; tput setaf 0)   # Black
export color_R=$(tput sgr0; tput setaf 1)   # Red
export color_G=$(tput sgr0; tput setaf 2)   # Green
export color_Y=$(tput sgr0; tput setaf 3)   # Yellow
export color_B=$(tput sgr0; tput setaf 4)   # Blue
export color_P=$(tput sgr0; tput setaf 5)   # Magenta
export color_C=$(tput sgr0; tput setaf 6)   # Cyan
export color_W=$(tput sgr0; tput setaf 7)   # White

### Bold text ###
export color_l=$(tput bold ; tput setaf 0)  # Black
export color_r=$(tput bold ; tput setaf 1)  # Red
export color_g=$(tput bold ; tput setaf 2)  # Green
export color_y=$(tput bold ; tput setaf 3)  # Yellow
export color_b=$(tput bold ; tput setaf 4)  # Blue
export color_p=$(tput bold ; tput setaf 5)  # Magenta
export color_c=$(tput bold ; tput setaf 6)  # Cyan
export color_w=$(tput bold ; tput setaf 7)  # White

### Background ###
export color_LB=$(tput sgr0; tput setab 0)  # Black
export color_RB=$(tput sgr0; tput setab 1)  # Red
export color_GB=$(tput sgr0; tput setab 2)  # Green
export color_YB=$(tput sgr0; tput setab 3)  # Yellow
export color_BB=$(tput sgr0; tput setab 4)  # Blue
export color_PB=$(tput sgr0; tput setab 5)  # Magena
export color_CB=$(tput sgr0; tput setab 6)  # Cyan
export color_WB=$(tput sgr0; tput setab 7)  # White



#########################
### Aliases/Functions ###
#########################
alias bn='basename'
alias py2='python2'
alias py='python'
alias ip2='ipython2'
alias ip3='ipython'
alias hc='herbstclient'
alias np2='relevant-track-np'
### Network ###

alias crsync='rsync -e ssh -axlz --progress'
alias cssh='ssh -c arcfour'
alias push='git push -u origin master'
alias disconnect='sudo netcfg -a'
alias connect='sudo netcfg -r'



send () {
    if [[ -z $2 ]]; then
        echo "Syntax:  $FUNCNAME HOST SOURCE DESTDIR"
        exit 1
    fi
    scp -r "$2" "$1:$3"
}

# Synchronizes relative paths between machines.
synchronize () {
    if [[ -z "${3}" || "${1}" != 'from' && "${1}" != 'to' ]]; then
        echo "Missing arguments. Syntax: {to|from} HOST PATH [PATH ...]"
        return 1
    fi
    direction="${1}"
    host="${2}:"
    sync="rsync -e ssh -al --progress"
    shift 2
    for item in "${@}"; do
        title "$HOSTNAME: Transferring '$item' $direction $host..."
        item=$(readlink -f "${item}")
        item=${item%/}
        if [[ "${direction}" == 'from' ]]; then
            ${sync} ${host}"${item}" "$(dirname "${item}")"
        else
            ${sync} "${item}" ${host}"$(dirname "${item}")"
        fi
    done
}
teach () {
    synchronize to ${*};
}
learn () {
    synchronize from ${*};
}

### Multimedia ###
alias vol='alsamixer'
alias eq='alsamixer -D equal'

### Utility ###
dream() {
    scott suspending machine
    sudo pm-suspend
}
alias rehash='. ${HOME}/.bashrc'
alias stime='date +"%m%d:%H%M.%S"'
title () {
    [[ ${TERM} != 'linux' ]] &&
        echo -e "\033]0;${*}\007";
}
histkill () {
    if which srm &> /dev/null; then
        srm -Drf "${HISTFILE}"
    else
        shred -fzu "${HISTFILE}"
    fi
    history -c
    exit
}
# Executes a command for each parameter to replace «:::».
# Example:
#   «iterate 'teach ::: Music Videos Pictures' machine1 machine2 ...»
iterate () {
    if [[ -z "$1" ]]; then
        echo "Missing arguments.  Syntax: COMMAND [ARGS] ::: [ARGS]"
        return 1
    fi
    cmd="$1"
    shift
    for x in "${@}"; do
        eval "${cmd//:::/${x}}"
    done
}

### Package management ###
aur () {
    title "$HOSTNAME: Downloading build..."
    cower --target "$abs_dir" "$@"
}
upgrade () {
    title "$HOSTNAME: Updating system..."
    sudo pacman -Syu "$@"
}
update () {
    title "$HOSTNAME: Updating package lists..."
    sudo pacman -Sy "$@"
}
new () {
    title "$HOSTNAME: Installing package..."
    sudo pacman -U "$@"
}
browse () {
    pacman -Qs "$@"
}
fuck () {
    title "$HOSTNAME: Removing package..."
    sudo pacman -Rsnc "$@"
}
build () {
    title "$HOSTNAME: Building ${PWD##*/}..."
    makepkg -fis "$@"
}
consider () {
    title "$HOSTNAME: Considering package"
    (pacman -Si ${*} || aur -ii ${*}) | less;
}
# Searches for package(s) in repos and ABS.
hunt () {
    title "$HOSTNAME: Searching repos and AUR for '$package'..."
    pacman -Ss "${@}"
    cower -s "${@}"
}
# Installs package(s) from repos, AUR.
eat () {
    if [[ "${*}" == '--noconfirm' ]]; then
        noconfirm=1
        shift
    fi
    for package in ${@}; do
        title "$HOSTNAME: Searching repos for '$package'..."
        echo -n "Looking for '${package}' in the package repos... "
        result=$(pacman -Sqs | grep -m1 "^${package}$")
        if [[ "${result}" ]]; then
            title "$HOSTNAME: Found package '$package'..."
            echo "Found: ${result}"
            [[ -z "${noconfirm}" ]] && read -n1 -p 'Install [Y/Enter], search AUR [A], or cancel [N]? ' feedback
            echo
            if [[ -z "${feedback}" || "${feedback}" == 'y' ]]; then
                title "$HOSTNAME: Installing package '$package'..."
                sudo pacman -S ${package}
            fi
        else
            echo 'Not found.'
        fi
        if [[ -z "${result}" || "${feedback}" == 'a' ]]; then
            title "$HOSTNAME: Searching AUR for '$package'..."
            echo "Looking for '${package}' in the AUR..."
            if [[ -d "$abs_dir/${package}" ]]; then
                title "$HOSTNAME: Found existing build for '$package'"
                echo 'Build exists.'
                [[ -z "${noconfirm}" ]] && read -n1 -p 'Overwrite [Y/Enter] or Cancel [N]? ' feedback
                echo
                [[ "${feedback}" && "${feedback}" != 'y' ]] &&
                    continue
            fi
            title "$HOSTNAME: Downloading build for '$package'"
            cower -df -t "$abs_dir" "${package}"
        fi
    done
}

### System ###
quietly () { "$@" &>/dev/null; }
alias shutdown='sudo shutdown now -h'
alias please='sudo'
# Adds self to group.
enlist () {
    for group in ${@}; do
        sudo gpasswd -a ${USER} ${group}
    done
}
# Removes self to group.
resign () {
    for group in ${@}; do
        sudo gpasswd -d ${USER} ${group}
    done
}

### File Management ###
alias ranger="PYTHONOPTIMIZE=1 /usr/bin/ranger"
alias r="PYTHONOPTIMIZE=1 /usr/bin/ranger"
alias ls='ls -Ash --color=auto'
alias l='ls'
alias perm='stat -c %a'
alias sedit="sudo ${EDITOR}"
f () {
    q=$1
    shift
    until [[ -z "$1" ]]; do
        find "$1" -iname "*$q*"
        shift
    done
}
c () {
    ls='ls -A -sh --color=auto'
    if [[ "${1}" ]]; then
        if [[ "${1}" == '-q' ]]; then
            ls='true'
            shift
        fi
        for dir in "${@}"; do
            if [[ -d "${dir}" ]]; then
                command cd "${dir}"
            else
                command cd *"${dir}"*
            fi
        done
    else
        command cd ~
    fi
    ${ls}
}
hide () {
    if [[ -z "${1}" ]]; then
        echo "Missing arguments. Syntax: PATH [PATH ...]"
        return 1
    fi
    for file in ${@}; do
        if [[ -e "${file}" ]]; then
            [[ "${file:0:1}" != '.' ]] && mv "${file}" ".${file}"
        else
            echo "File \"${file}\" does not exist."
        fi
    done
}
show () {
    basename=${0##*/}
    if [[ -z "${1}" ]]; then
        echo "Missing arguments. Syntax: PATH [PATH ...]"
        return 1
    fi
    for file in "${@}"; do
        if [[ -e "${file}" ]]; then
            [[ "${file:0:1}" == '.' ]] && mv "${file}" "${file:1}"
        else
            echo "File \"${file}\" does not exist."
        fi
    done
}
# Makes passes over a file or directory before unlinking.
defile () {
    for file in "${@}" ]]; do
        if which srm &> /dev/null; then
            srm -srf ${*}
        elif [[ -e "${file}" ]]; then
            if [[ -d "${file}" ]]; then
                find "${file}" -type f -exec shred -fzu "{}" \;
            else
                shred -fzu "${file}"
            fi
            rm -rf "${file}"
        fi
    done
}


##############
### Prompt ###
##############
# Generates prompt color scheme based on host- and username.
color_Tn () {
    n=$((0x$(echo ${HOSTNAME} | md5sum | cut -d' ' -f1)))
    echo $((${n/-/} + UID))
}
color_Sn () {
    n=$((0x$(echo ${USER}${HOSTNAME} | md5sum | cut -d' ' -f1)))
    echo $((${n/-/}))
}
colors_T=(R G Y B P C)
colors_S=(R G Y B P C N)
color_T="color_${colors_T[$(($(color_Tn) % ${#colors_T[@]}))]}"
color_t=$(echo ${color_T} | tr '[:upper:]' '[:lower:]')
color_S="color_${colors_S[$(($(color_Sn) % ${#colors_S[@]}))]}"
color_s=$(echo ${color_S} | tr '[:upper:]' '[:lower:]')
unset colors_T
unset colors_S
unset color_Tn
unset color_Sn
export color_T=${!color_T}
export color_t=${!color_t}
export color_S=${!color_S}
export color_s=${!color_s}

prompt_function () {
    title "${HOSTNAME}"
}
#export PROMPT_COMMAND='prompt_function'
if ((UID != 0)); then
    export PS1="\[$color_S\]\h\[$color_N\]:\[$color_t\]\w\[$color_T\]\\$\[$color_N\] "
else
    export PS1="\[$color_s\]\h\[$color_t\]:\[$color_s\]\w\[$color_S\]\\$\[$color_N\] "
fi



##################
### Completion ###
##################
#complete -cf sudo
. /usr/share/doc/pkgfile/command-not-found.bash



#####################
### Miscellaneous ###
#####################
[[ -r "${HOME}/.dircolors" ]] &&
    eval "${HOME}/.dircolors" || eval "$(dircolors -b)"

title ${HOSTNAME}

### Fortune Cookies ###
if type -p fortune >/dev/null; then
    fortune=$(fortune)
    longest=$(printf '%s\n' "$fortune" | awk 'BEGIN {L=0}{if (length > L){L=length}}END{print L}')
    header='=== Fortune Cookie ==='
    unset footer
    ((${#header} > longest)) && longest=${#header}
    for ((n=0; n<longest; n++)); do
        footer+='='
    done
    if ((${#header} < longest)); then
        longest=$((longest - ${#header}))
        for ((n=0; n<longest; n++)); do
            header+='='
        done
    fi
    clear

    printf "${color_C}${header}${color_G}\n%s\n${color_C}${footer}${color_N}\n\n" \
        "$fortune"
fi

### Reminders ###
alias remind='tell'
type -p tell >/dev/null && tell me about reminders
