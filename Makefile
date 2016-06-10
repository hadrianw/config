all: dwm dotfiles /usr/share/xsessions/xsession.desktop

dotfiles:
	cd dotfiles && for i in *; do cp -rv "$$i" "$(HOME)/.$$i"; done
	xrdb -merge $(HOME)/.Xdefaults

dwm:
	(cd dwm && git pull origin master) || git clone http://git.suckless.org/dwm
	if [ dwm.config.h -nt dwm/config.h ]; then cp dwm.config.h dwm/config.h; fi
	cd dwm && make && sudo make install

/usr/share/xsessions/xsession.desktop: /etc/X11/Xsession xsession.desktop
	sed -i s%^Exec=.*%Exec=$<% xsession.desktop
	sudo cp xsession.desktop /usr/share/xsessions/

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

.PHONY: all dwm dotfiles bashrc ubuntu
