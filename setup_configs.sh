#!/bin/bash

pre_define () {
  sys_names="CentOS \
             MacOS \
             None-of-above"
  sys_u=$(uname -s)
  case $sys_u in
    Darwin)
      sys_name=MacOS
      ;;
    Linux)
      sys_name=CentOS
      ;;
  esac
}

select_os_name () {
  sys_name=$1
  while [ 1 ];
  do
    [ -n "${sys_name}" ] \
      && echo "${sys_names}" | grep -wq "${sys_name}" \
        && break
    echo "> Invalid choice. Please choose a system now:"
    select sys_name in $sys_names; do break; done
    echo "> System name you've selected: [${sys_name}]"
  done
  sleep 1
}

choose_yes_or_no () {
  read -p "> Input(yes/y/Y) or (no/n/N/...): " yes_or_no
  case $yes_or_no in
    yes|y|Y)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

deploy_bashgem () {
  echo "--- deploying .bashgem into .bashrc:"
  [ -f ~/.bashrc ] \
  && ( cp .bashgem ~/.bashgem \
    && ( grep -q "source ~/.bashgem" ~/.bashrc \
      && echo " |--- Bashgem updated." \
      || ( echo -e "\n\n# My bashgem\n[ -f ~/.bashgem ] && source ~/.bashgem" >> ~/.bashrc \
        && echo " |--- Successfully added bashgem into .bashrc." \
        || echo " |--- Failed to add bashgem into .bashrc")) \
    || echo " |--- Bashgem copy failed." )\
  ||  echo -e " |--- There is no .bashrc in ~\n   |--- run: touch ~/.bashrc"
  sleep 1
}

install_ack () {
  if [ "$1"x == "CentOS"x ]; then
    rpm -qa | egrep -q "^ack-" || (sudo yum install epel-release -y && sudo yum install ack -y)
  elif [ "$1"x == "MacOS"x ]; then
    brew list | grep -q ack || brew install ack
  else
    echo "Please install ack to use Ack plugin in vim."
  fi
}

do_deploy_vimrc () {
  cp .vimrc ~/.vimrc
  mkdir -p ~/.vim/vundle/plugin
  echo " |--- install vundle:"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo " |--- install ack:"
  install_ack $sys_name
  echo " |--- vimrc deployed. => Run :PluginInstall in vim."
}

deploy_vimrc () {
  echo "--- deploy .vimrc:"
  if [ -f ~/.vimrc ]; then
    echo " |--- ~/.vimrc existed. Do you want to overwrite?"
    choose_yes_or_no
    [ $? -eq 0 ] \
      && echo " |--- .vimrc deployment aborted." \
      && exit 0
  fi
  do_deploy_vimrc
  sleep 1
}

do_deploy_gitconfig () {
  cp .gitconfig ~/.gitconfig
  if [ "$1"x = "individually"x ]; then
    while [[ -z "${git_user_name}" || -z "${git_user_email}" ]];
    do
      echo "git user name: "$git_user_name
      echo "git user email: "$git_user_email
      read -p "Input git config --global user.name: " git_user_name
      read -p "Input git config --global user.email: " git_user_email
    done
    echo "   |--- gitconfig name and email"
    git config --global user.name $git_user_name
    git config --global user.email $git_user_email
  fi
  echo "--- .gitconfig deployed."
}

deploy_gitconfig () {
  echo "--- deploy .gitconfig:"
  if [ -f ~/.gitconfig ]; then
    echo " |--- ~/.gitconfig existed. Do you want to overwrite?"
    choose_yes_or_no
    [ $? -eq 0 ] && echo " | --- deploy .gitconfig aborted." && exit 1
  fi
  echo "Do you want to set git user name and email individually?"
  choose_yes_or_no
  [ $? -eq 1 ] && git_user_email_option="individually"
  do_deploy_gitconfig $git_user_email_option
}

deploy_tmuxconf () {
  cp .tmux.conf ~/.tmux.conf
  echo "--- .tmux.conf deployed."
}

main_func () {
  pre_define

  while getopts abhn:vgt option
  do
    case $option in
      a)
        echo "Doing all deployment things by default..."
        deploy_bashgem
        do_deploy_gitconfig
        do_deploy_vimrc
        break
        ;;
      n)
        # echo "-n get |${OPTARG}|"
        select_os_name $OPTARG
        ;;
      b)
        # echo "-a get"
        deploy_bashgem
        ;;
      g)
        # echo "-g get"
        deploy_gitconfig
        ;;
      v)
        # echo "-v get"
        deploy_vimrc
        ;;
      t)
        deploy_tmuxconf
        ;;
      h)
        # echo "-h get"
        echo -e "\n\033[44;37m Help:  \033[0m"
        echo " -a           : do all things by default without asking. Useful if"
        echo "                it's the first time setup configs in CentOS."
        echo " -b           : deploy bashgem."
        echo " -n <name>    : choose system you are deploying. Default is CentOS."
        echo "                supported system names: [ CentOS, MacOS ]"
        echo " -v           : deploy vimrc."
        echo " -g           : deploy gitconfig."
        echo "-------------------------------------------------------------------"
        echo -e "\n     Example <1> :  ./setup_configs.sh -n CentOS -b -v -g"
        echo -e "\n     Example <2> :  ./setup_configs.sh -bv"
        echo -e "\n   Quick Example :  ./setup_configs.sh -a\n"
        exit 1
        ;;
      *)
        echo "Run: ./setup_configs.sh -h"
        exit 1
    esac
  done
  echo ">>>>---DEPLOY-END----->"
}

main_func $*

