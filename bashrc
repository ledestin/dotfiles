# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:~/work/utils:~/work/mkat:~/work/dev-scripts

export LC_MESSAGES=C
if [ -z "$LANG" ]; then
  export LANG=ru_RU.UTF-8
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
  # Locale and user-friendly related stuff.
  case "$OS" in
    SunOS) # Hostile Sun environment.
      export EDITOR=vim
      export PAGER=less
      export TERMINFO=$HOME/.terminfo
      export MANPATH=/opt/csw/share/man:/usr/share/man

      alias vi='vim'
      ;;
    *)
      export LC_MESSAGES=C
      export VISUAL=vim
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
      ;;
  esac

  # Terminal title.
  case "$TERM" in                                                         
    screen|xterm*)                                                             
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
      PROMPT_COMMAND='echo -ne "\033]2;${windowName} (${HOSTNAME})\007"' ;;
  esac                                                                    

  # Shell settings.

  # Git branch in prompt.
  export GITAWAREPROMPT=~/.bash/git-aware-prompt
  source "${GITAWAREPROMPT}/main.sh"

  PS1='\[\033[32m\]\u@\h \[\033[33m\w\033[0m\] \[\033[32m$git_branch\033[0m\]\[$txtred\]$git_dirty\[$txtrst\]\n\$'
  MAIL="~/Mail/mbox"

  # don't put duplicate lines in the history. See bash(1) for more options
  HISTCONTROL=ignoredups
  shopt -s nocaseglob
  shopt -s extglob
  . ~/.bash_completions
  . ~/.bash/git-completion.bash
  . ~/.bundler-exec.sh
  alias rake='run-with-bundler xvfb-run rake'
  alias rspec='run-with-bundler xvfb-run rspec'

  # Rails/Easil
  export DEV_HOST=dannan

  # Program settings.

  # ls(1)
  type dircolors &>/dev/null && eval `dircolors -b`
  if [ "$OS" = 'Darwin' ]; then
    ls_opts='-G';
  else
    ls_opts='--color=auto --show-control-chars'
  fi
  alias ls="ls $ls_opts -h"
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

  # Debian
  alias ac='apt-cache'
  alias acs='apt-cache search'
  alias ag='apt-get'
  alias agi='ag install'

  # Mail
  alias gmail='mutt -F ~/.muttrc-gmail'

  # Time
  alias blagotime="TZ='Asia/Yakutsk' date"
  alias japtime="TZ='Asia/Tokyo' date"
  alias moscowtime="TZ='Europe/Moscow' date"
  alias samtime="TZ='Europe/Samara' date"
  alias vladtime="TZ='Asia/Sakhalin' date"
  alias wakeat="date --date='+10 hours'"

  # ssh(1)
  alias scid='ssh-copy-id -i ~/.ssh/id_dsa.pub'

  # bundler(1)
  alias be='bundle exec'

  # git(1)
  alias g='git'
  alias ga='git add'
  alias gc='git commit'
  alias gd='git diff'
  alias gl='git log'
  alias gs='git show'
  alias gst='git st'
  alias gpr='git pull --rebase'
  alias gm='git branch --merged master'

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

if `type rbenv &>/dev/null`; then
  eval "$(rbenv init -)";
fi

function init_ssh_agent {
  eval `ssh-agent -s`
  ssh-add
}

# Load host-local config.
LOCAL_CONFIG=~/".bash_$HOSTNAME"
if [ -f "$LOCAL_CONFIG" ]; then . "$LOCAL_CONFIG"; fi
