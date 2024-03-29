all: dotfiles

dotfiles: bashrc
	cd dotfiles && for i in *; do cp -rv "$$i" "$$HOME/.$$i"; done
	xrdb -merge $(HOME)/.Xdefaults

bashrc:
	sed -i "s%^source .*/bashrc_append\"$$%%" "$$HOME/.bashrc"
	echo "source \"$$(readlink -f bashrc_append)\"" >> "$$HOME/.bashrc"

GIT_PROTOCOL=git
#GIT_PROTOCOL=https

dwm:
	(cd $@ && git pull origin master) || git clone $(GIT_PROTOCOL)://git.suckless.org/$@
	if [ ! -e dwm/config.h -o dwm.config.h -nt dwm/config.h ]; then cp dwm.config.h dwm/config.h; fi
	cd $@ && make && sudo make install

dmenu:
	(cd $@ && git pull origin master) || git clone $(GIT_PROTOCOL)://git.suckless.org/$@
	rm -f dmenu/config.h
	cd $@ && make && sudo make install

xsession: /usr/share/xsessions/xsession.desktop
VPATH=.:/etc/X11/xinit:/etc/X11
/usr/share/xsessions/xsession.desktop: Xsession xsession.desktop
	sed s%^Exec=.*%Exec=$<% xsession.desktop | sudo tee $@ > /dev/null

void-install:
	sudo xbps-install \
		rxvt-unicode \
		gvim \
		htop the_silver_searcher \
		base-devel git git-gui \
		libX11-devel libXinerama-devel libXft-devel \
		jq

ubuntu-install:
	sudo apt-get install \
		rxvt-unicode \
		vim vim-gtk \
		htop silversearcher-ag \
		thunar \
		build-essential git git-gui \
		libx11-dev libxinerama-dev libxft-dev \
		suckless-tools \
		sharutils
ubuntu: ubuntu-install dwm xsession
ubuntu-vm: ubuntu
	sudo apt-get install \
		openssh-server
	sudo systemctl ssh start
	sudo systemctl enable ssh.service

centos-install:
	sudo yum install \
		rxvt-unicode \
		gvim \
		htop the_silver_searcher \
		google-droid-sans-fonts google-droid-sans-mono-fonts \
		xclip \
		gperftools kdesdk createrepo
centos: centos-install dwm dmenu xsession

.PHONY: all dotfiles bashrc dwm dmenu xsession ubuntu centos
