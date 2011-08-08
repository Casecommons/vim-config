How to install this vim config:

- git clone this repo into ~/.vim: `git clone git@github.com:pivotal-ipsofacto/vim-config.git .vim`
- cd ~/.vim
- git submodule init
- git submodule update
- ln -s ~/.vim/vimrc ~/.vimrc

the command-T module seems to have trouble installing properly, so you may have to 

- manually add Command-T to the bundle: `https://github.com/wincent/Command-T.git .vim/bundle/command-t`
- run `ruby .vim/bundle/command-t/ruby/command-t/extconf.rb`
- run `make`


