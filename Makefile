all: dwm dmenu dotfiles xsession

dotfiles:
	cd dotfiles && for i in *; do cp -rv "$$i" "$(HOME)/.$$i"; done
	xrdb -merge $(HOME)/.Xdefaults

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

bashrc:
	sed -i 's%^source ".*/bashrc_append$$"%%' "$(HOME)/.bashrc"
	echo source $$(readlink -f bashrc_append) >> "$(HOME)/.bashrc"

ubuntu:
	sudo apt-get install \
		rxvt-unicode \
		vim vim-gtk \
		htop silversearcher-ag \
		thunar \
		build-essential git git-gui \
		libx11-dev libxinerama-dev libxft-dev \
		suckless-tools \
		sharutils

centos: dmenu
	sudo yum install \
		rxvt-unicode \
		gvim \
		htop the_silver_searcher \
		google-droid-sans-fonts google-droid-sans-mono-fonts \
		xclip \
		gperftools kdesdk createrepo

.PHONY: all dwm dmenu dotfiles xsession bashrc ubuntu centos
