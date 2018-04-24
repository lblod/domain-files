#!/bin/bash -i

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

cloneOrPullRepository() {
    repo=$1
    dirname=`echo $repo | sed -r 's/(https:\/\/|git@)github.com(:|\/)[a-z]+\/([a-z-]+)(.git)?/\3/'`
    if [ -d $dirname ];then
        pushd $dirname > /dev/null
        git pull > /dev/null
        popd > /dev/null
    else
        git clone $repo > /dev/null
    fi
    echo $dirname
}

generateEmber() {
    repo=$1
    domainSource=$2
    dirname=`cloneOrPullRepository $repo`
    echo "==== $dirname ===="
    pushd $dirname > /dev/null
    ed npm install
    commands=`docker run --rm -v $work_dir/$domainSource/config/resources/:/config -i command-generator | grep ember | sed -e 's/ember/edi ember/'`
    while read line;do
        $line < /dev/tty
    done <<< "$commands"
    git add .
    git diff --cached
    git status
    confirm "Commit files? [y/N]" && git commit -m "syncing shared domain configuration"
    popd > /dev/null
}

if [ ! -d $1 ];then
   echo "Error : $1 is not a directory"
   echo
   echo "Usage: "
   echo " $0 /your/work/directory"
   exit -1
fi

domain_dir=`pwd`
work_dir="$( cd "$1" ; pwd -P )"

echo "will attempt to sync domain files to repositories cloned in $work_dir"

pushd $work_dir > /dev/null
for repository in ${repositories[*]}; do
    dirname=`cloneOrPullRepository $repository`
    echo "==== $dirname ==="
    pushd $dirname > /dev/null
    for domain in $domain_dir/master-*-domain.lisp; do
        basename=`basename $domain`
        filename=`echo $basename | sed -e 's/master-/slave-/'`
        cp $domain config/resources/$filename
        git add config/resources/$filename
    done
    git diff --cached
    git status
    confirm "Commit files? [y/N]" && git commit -m "syncing shared domain configuration" &&
    confirm "Push commit? [y/N]" && git push
    popd > /dev/null
done

confirm "update admin applications? [y/N]" || exit 0
echo "setting up command generator"
dirname=`cloneOrPullRepository "https://github.com/tenforce/ember-mu-application-generator-generator"`
echo "==== $dirname ==="
pushd $dirname > /dev/null

# fix generator
lastline=`tail -n 1 startup.lisp`
if [[ $lastline != "(exit)" ]];then
    echo "(exit)" >> startup.lisp
fi

docker build -t command-generator . > /dev/null
popd > /dev/null

# demo editor
generateEmber "git@github.com:lblod/frontend-editor-admin" "app-demo-editor"
# loket
generateEmber "git@github.com:lblod/frontend-loket-admin" "app-digitaal-loket"
