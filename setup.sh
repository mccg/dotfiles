#!/bin/bash

pre_define () {
  sys_names="CentOS \
             Ubuntu \
             Raspbian \
             MacOS \
             None-of-above"
  sys_u=$(uname -s)
  case $sys_u in
    Darwin)
      sys_name=MacOS
      ;;
    Linux)
      local id_expression=`cat /etc/os-release | egrep "^ID="`
      case $id_expression in
        *centos*)    sys_name=CentOS;;
        *fedora*)    sys_name=Fedora;;
        *ubuntu*)    sys_name=Ubuntu;;
        *raspbian*)  sys_name=Raspbian;;
      esac
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
  if [ "$1" == "CentOS" ]; then
    rpm -qa | egrep -q "^ack-" || (sudo yum install epel-release -y && sudo yum install ack -y)
  elif [ "$1" == "Fedora" ]; then
    sudo yum install ack -y
  elif [ "$1" == "MacOS" ]; then
    brew list | grep -q ack || brew install ack
  elif [ "$1" == "Ubuntu" ] || [ "$1" == "Raspbian" ]; then
    apt list git 2>/dev/null | grep -q ack || (sudo apt-get install ack-grep -y)
  else
    echo "Please install ack to use Ack plugin in vim."
  fi
}

do_deploy_vimrc () {
  cp .vimrc ~/.vimrc
  echo " |--- install vim-plug:"
  curl -sfLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo " |--- install ack:"
  install_ack $sys_name
  vim -E +PlugInstall +vi +q +q
  echo " |--- vimrc deployed."
}

deploy_vimrc () {
  echo "--- deploy .vimrc:"
  if [ -f ~/.vimrc ]; then
    echo " |--- ~/.vimrc existed. Do you want to overwrite?"
    choose_yes_or_no
    [ $? -eq 0 ] \
      && echo " |--- .vimrc deployment aborted." \
      && return 0
  fi
  do_deploy_vimrc
  sleep 1
}

deploy_vimdict () {
  echo " |--- deploy vim dicts:"
  rsync -av dict ~/.vim/
}

do_deploy_gitconfig () {
  cp .gitconfig ~/.gitconfig
  if [ "$1" == "individually" ]; then
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

deploy_git_stuff () {
  local src_dir_path=${0%/*}
  if test "attr" == "$1"; then
    echo gitattributes: $src_dir_path "=>" `pwd`
    cp $src_dir_path/.gitattributes `pwd`/.gitattributes
  elif test "ignore.unity" == "$1"; then
    echo ignore: $src_dir_path "=>" `pwd`
    cp $src_dir_path/.gitignore.unity `pwd`/.gitignore
  fi
}

main_func () {
  pre_define

  while getopts abG:ghn:tv option
  do
    case $option in
      a)
        echo "Doing all deployment things by default..."
        deploy_bashgem
        do_deploy_gitconfig
        do_deploy_vimrc
        deploy_tmuxconf
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
      G)
        deploy_git_stuff $OPTARG
        ;;
      g)
        # echo "-g get"
        deploy_gitconfig
        ;;
      v)
        # echo "-v get"
        deploy_vimrc
        deploy_vimdict
        ;;
      t)
        deploy_tmuxconf
        ;;
      h)
        # echo "-h get"
        echo ""
        echo -e "\033[44;37m       \033[0m"
        echo -e "\033[44;37m Help: \033[0m"
        echo -e "\033[44;37m       \033[0m"
        echo " -a           : do all things by default without asking. Useful if"
        echo "                it's the first time setup configs in CentOS."
        echo " -b           : deploy bashgem."
        echo " -n <name>    : choose system you are deploying. Default is CentOS."
        echo "                supported system names: [ CentOS, MacOS ]"
        echo " -v           : deploy vimrc."
        echo " -g           : deploy gitconfig."
        echo " -G <stuff>   : deploy git stuff"
        echo " -t           : deploy tmux conf"
        echo "-------------------------------------------------------------------"
        echo -e "\n     Example <1> :  ./setup.sh -n CentOS -b -v -g -t"
        echo -e "\n     Example <2> :  ./setup.sh -bv"
        echo -e "\n   Quick Example :  ./setup.sh -a"
        echo -e "\n   Quick Example :  ./setup.sh -G attr"
        echo ""
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

