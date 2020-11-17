# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:~/work/utils:~/work/mkat:~/work/dev-scripts:/snap/bin

export LC_MESSAGES=C
if [ -z "$LANG" ]; then
  export LANG=en_NZ.UTF-8
fi

export NODE_PATH=/usr/local/lib/node_modules

# OS-related settings.
OS=`uname`
case "$OS" in
  Linux)
    ulimit -u 2000

    if [ "$HOSTNAME" = 'karn' ]; then
      # Was unable to build ruby 1.9, wasn't enough allowed processes and POSIX
      # message queues.
      ulimit -q 281921
    fi
    ;;
  CYGWIN*)
    if [ -n "$WINDIR" ]; then PATH="$PATH:`cygpath.exe $WINDIR/system32`"; fi
    ;;
  SunOS)
    # Prepend PATH with sunfreeware path.
    PATH="/opt/csw/bin:/opt/csw/sbin:$PATH"
  ;;
esac

# Interactive-shell related.
if [ -n "$PS1" ]; then
  date_cmd="date"

  # Locale and user-friendly related stuff.
  case "$OS" in
    Darwin)
      date_cmd="gdate"
      alias br="brightness -l"
      ;;
    SunOS) # Hostile Sun environment.
      export EDITOR=vim
      export PAGER=less
      export TERMINFO=$HOME/.terminfo
      export MANPATH=/opt/csw/share/man:/usr/share/man

      alias vi='vim'
      ;;
    Linux)
      FRAMEBUFFER_RUN='xvfb-run -a'
      ;;
  esac

  export LC_MESSAGES=C
  export VISUAL=vim
  export EDITOR="$VISUAL"
  export FTP_PASSIVE=1
  export DEBEMAIL='ledestin@gmail.com'
  export OPERAPLUGINWRAPPER_PRIORITY=0
  # So that gqview doesn't complain about non-utf filenames.
  export G_BROKEN_FILENAMES=1

  # Terminal-locale-related settings.
  # Russian locale, unless terminal is kterm.
  #
  # The reason for why a Linux distribution should set LANG in /etc/profile is
  # that this makes it most easy for user to override that system default using
  # the individual LC_* variables. If LC_ALL is set, then this selective
  # override functionality would not be available to users.
  case "$TERM" in
    kterm)
      export XMODIFIERS="@im=kinput2"
      export LANG=ja_JP.eucJP
      ;;
    *)
      export LESSCHARDEF=8bcccbcc18b95.b41.b15.b7.
      ;;
  esac

  # Terminal title.
  case "$TERM" in
    screen|xterm*)
      if [ -e /usr/share/terminfo/x/xterm+256color -o "$OS" = "Darwin" ]; then
        export TERM='xterm-256color'
      else
        export TERM='xterm-color'
      fi

      # If this is an xterm set the title to "WindowName (hostname)".
      if [ -z "$WINDOWID" ]; then
	# FIXME: Ugly hack because WINDOWID gets purged by sudo. Need to
	# investigate about preserving environment with sudo. Other option is
	# exporting something like WINDOW_NAME, but that would make it static
	# (though practically, I don't fancy it changing). But, WINDOW_NAME will
	# also be purged, no doubt :(
	case "$USER" in
	  root) windowName='Root console' ;;
	  *)    windowName='Unknown' ;;
        esac
      else
	# Get window title from WM_CLASS property.
	#
	# Note: FVWM is unable to work with window names that have spaces, thus
	# I have to use `Root-console' in FVWM instead of `Root console'. Thus,
	# I assume that I it's fine to convert `-'s to ` 's.
	windowName=`xprop -notype -id $WINDOWID WM_CLASS | \
	  sed 's/^[^"]\+"//; s/".\+$//; s/-/ /g'`
      fi
      PROMPT_COMMAND='echo -ne "\033]2; [${HOSTNAME}]\007"' ;;
  esac

  # Shell settings.

  # Git branch in prompt.
  export GITAWAREPROMPT=~/.bash/git-aware-prompt
  source "${GITAWAREPROMPT}/main.sh"

  if [ "$OS" = "Darwin" ]; then
    txtrst="$txtwht"
  fi
  PS1='\[\033[33m\]\u\e[90m@\e[35m\h \[\033[33m\w\033[0m\] \[\033[32m$git_branch\033[0m\]\[$txtred\]$git_dirty\[$txtrst\]\n\$'
  MAIL="~/Mail/mbox"

  # don't put duplicate lines in the history. See bash(1) for more options
  HISTCONTROL=ignoredups
  shopt -s nocaseglob
  shopt -s extglob
  . ~/.bash_completions
  . ~/.bash/git-completion.bash
  . ~/.bash/git-flow-completion.bash
  . ~/.bundler-exec.sh
  alias reload-bashrc=". ~/.bashrc"

  # Ruby
  alias rake="run-with-bundler $FRAMEBUFFER_RUN rake"

  run_rspec_via_spring_or_binstub_or_bundler() {
    if [ -f "./bin/spring" ]; then
      ./bin/spring rspec "$@"
    elif [ -f "./bin/rspec" ]; then
      ./bin/rspec "$@"
    else
      run-with-bundler $FRAMEBUFFER_RUN rspec
    fi
  }
  alias rspec="run_rspec_via_spring_or_binstub_or_bundler"

  # Rails/Easil
  export DEV_HOST=dannan

  # Program settings.

  # overlord_quote(1)
  for character in shalltear albedo aura mare demiurge cocytus entoma narberal \
    nabe lupusregina yuri solution ainz momonga baraja evileye; do
    eval "alias $character='overlord_quote $character'"
  done

  # ls(1)
  type dircolors &>/dev/null && eval `dircolors -b`
  alias ls='exa'
  alias ll='ls -l'
  alias la='ls -A'

  # Coreutils
  alias le='less'
  alias df='df -h'
  alias du='du -h'
  alias ut='uptime'
  alias uz='unzip'
  alias uzl='unzip -l'
  alias pget='wget -np -krpN -U "Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686) Opera 7.54  [en]"'
  alias pgetp='wget -krpN -U "Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686) Opera 7.54  [en]"'
  alias diskusage="du -h -d1 2> /dev/null | sort -hr"
  alias tz="$date_cmd -d "

  # Serve HTTP
  alias serve-current-dir-http="ruby -run -e httpd . -p 9090"

  # Currency exchange
  alias nzd="lumione 1 nzd usd"
  alias rub="lumione 1 usd rub"

  # Weather
  alias weather="curl wttr.in?n"

  # Debian
  alias ac='apt-cache'
  alias acs='apt-cache search'

  # K8s
  alias k="microk8s.kubectl"

  # Hardware
  alias motherboard='dmidecode -t 2'

  # Mail
  alias gmail='mutt -F ~/.muttrc-gmail'

  # Time
  alias blagotime="TZ='Asia/Yakutsk' date"
  alias japtime="TZ='Asia/Tokyo' date"
  alias moscowtime="TZ='Europe/Moscow' date"
  alias minsktime="TZ='Europe/Minsk' date"
  alias vladtime="TZ='Asia/Sakhalin' date"
  alias wakeat="date --date='+10 hours'"

  # youtube-dl(1)
  alias youtube-dl-best="youtube-dl -f bestvideo+bestaudio"

  # ssh(1)
  alias scid='ssh-copy-id -i ~/.ssh/id_dsa.pub'

  # bundler(1)
  alias be='bundle exec'

  # git(1)
  alias g='git'
  alias gb="git checkout -b"
  alias ga='git add'
  alias gc='git commit'
  alias gd='git diff'
  alias gdc='gd --cached'
  alias gl='git log'
  alias gs='git show'
  alias gst='git st'
  alias gpr='git pull --rebase'
  alias gm='git branch --merged master'
  alias git-remove-commit='git reset --soft HEAD^'
  alias gcl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  alias gcmb="git branch --merged | grep -Ev '(^\*|master)' | xargs git branch -d"
  alias gprunestale="git fetch --prune --all"

  # Rails
  rails="./bin/rails"

  alias r="$rails"
  alias rc="r console"
  alias rcs='rc --sandbox'
  alias rs="r server"

  # svn(1)
  export svn=file:///var/lib/svn
  alias svn='LANG=C svn'
  alias dstat='svn diff | diffstat'
  alias slog='svnlog'
  alias st='svn st | grep ^\? | sed "s/^\?[[:blank:]]\+//"'
  alias stf='svn st'
  alias stfl="stf | awk '{ print \$2 }'"
  alias stadd='st | xargs -ivar svn add "var"'
  alias sup='svn up'

  # Misc programming.
  export CVSROOT=/var/lib/cvs
  alias dl='dh_listpackages'

  # dict(1)
  DICTL_CHARSET='KOI8-R'
  alias di='dictl'

  # Wallpapers
  alias delbgpic='rm "`cat ~/.chbg_history`"'
  alias curpic='cat ~/.chbg_history'

  # Music
  alias np='nptag --np="now-playing full"'
  alias p='deadbeef'
  alias pe='p --queue'
  alias pn='p --next'
  alias pp='p --prev'
  alias pt='p --toggle-pause'
  alias nptag='nptag --np="now-playing full"'
  alias tartist='nptag'
  alias talbum='nptag --album'
  alias tsong='nptag --album --song'

  # mplayer(1)
  alias mp='mplayer -quiet -mc 0 -nojoystick -cache 8192'
  alias mphd='mp -vo vdpau -vc ffmpeg12vdpau,ffh264vdpau,ffwmv3vdpau,ffvc1vdpau,'
  alias mpf='mp -fs'
  alias mpq='mp -vf pp=ac'
  alias mplq='mp -framedrop -nobps -vfm ffmpeg' #-lavdopts lowres=1:fast:skiploopfilter=all'
  alias mps='mp -vf-add expand=0:-75:0:0'
  alias mpr='mp -af resample=45056'

  # News
  export NNTPSERVER=localhost

  # PDF
  alias acroread='nice -n19 acroread'
fi

if [ -r "${HOME}/.bash-ctx/bash-ctx" ]; then
    source "${HOME}/.bash-ctx/bash-ctx"
fi

function init_ssh_agent {
  eval `ssh-agent -s`
  ssh-add
}

function last_migration {
  "$VISUAL" db/migrate/$(ls db/migrate/ | sort | tail -1)
}

# Load host-local config.
LOCAL_CONFIG=~/".bash_$HOSTNAME"
if [ -f "$LOCAL_CONFIG" ]; then . "$LOCAL_CONFIG"; fi

DISCO_CONFIG=~/.bash_disco
if [ -f "$DISCO_CONFIG" ]; then . "$DISCO_CONFIG"; fi

if [ -d ~/.asdf ]; then
  . $HOME/.asdf/asdf.sh

  . $HOME/.asdf/completions/asdf.bash

  PATH="$PATH:$(yarn global bin)"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
