#!/bin/bash
domain_dir=`pwd`
work_dir=$1

repositories=(git@github.com:lblod/app-demo-editor.git
git@github.com:lblod/app-mandatendatabank.git
git@github.com:lblod/app-digitaal-loket.git
git@github.com:lblod/json-api-documentation.git)

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

echo "will attempt to sync domain files to repositories cloned in $1"


if [ ! -d $work_dir ];then
   echo "Error: $1 is not a directory"
   echo
   echo "Usage: "
   echo " $0 /your/work/directory"
   exit -1
fi

pushd $work_dir
for repository in ${repositories[*]}; do
    dirname=`echo $repository | sed -r 's/git@github.com:lblod\/([a-z-]+).git/\1/'`

    echo $dirname
    if [ -d $dirname ];then
        pushd $dirname
        git pull
        popd
    else
        git clone $repository;
    fi
    pushd $dirname
    for domain in $domain_dir/master-*-domain.lisp; do
        basename=`basename $domain`
        filename=`echo $basename | sed -e 's/master-/slave-/'`
        cp $domain config/resources/$filename
        git add config/resources/$filename
    done
    git status
    confirm "Commit files? [y/N]" && git commit -m "syncing shared domain configuration" &&
    confirm "Push commit? [y/N]" && git push
    popd
done
popd
