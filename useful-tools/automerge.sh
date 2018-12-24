#!/bin/bash

# default source repo address
# ssh://git@origin.www.code.dtf.lighting.com:7999/lwcp/ssdk-node.git
#DEFAULT_SRC_REPO="ssh://git@origin.www.code.dtf.lighting.com:7999/lwcp/ssdk-node.git"
DEFAULT_SRC_REPO=ssh://origin.www.code.dtf.lighting.com:7999/~bin.li_lighting.com/test_merge_tool-02.git
# default destination repo address
#DEFAULT_DST_REPO="ssh://git@origin.www.code.dtf.lighting.com:7999/lwcp/ssdk-node.git"
DEFAULT_DST_REPO=ssh://origin.www.code.dtf.lighting.com:7999/~bin.li_lighting.com/test_merge_tool-01.git

CUR_DIR=`pwd`


# script name
SCRIPT_NAME=$0

# ./automerge.sh --h for help
if [ "$1"x == "--h"x ]; then
	echo "********************************Usage**********************************************"
	echo "** $SCRIPT_NAME --h: script usage help                                           **"
	echo "** $SCRIPT_NAME: run by using default code repo address                          **"
	echo "** $SCRIPT_NAME source-repo dest-repo: run by using input repo address           **"
	echo "***********************************************************************************"
	exit 0
fi

# source repo address from terminal
SRC_REPO=$1
DST_REPO=$2

echo "$SCRIPT_NAME start running ..."
echo "Current work directory: $CUR_DIR"
src_repo_addr=$DEFAULT_SRC_REPO
dst_repo_addr=$DEFAULT_DST_REPO

# decide which source repo address to be used
if [ "x$SRC_REPO" == "x$DEFAULT_SRC_REPO" ]; then
	src_repo_addr=$DEFAULT_SRC_REPO
elif [ "x$SRC_REPO" == "x" ]; then
	src_repo_addr=$DEFAULT_SRC_REPO
else
	src_repo_addr=$SRC_REPO
fi
echo "Source repo address: $src_repo_addr"

# decide which destination repo address to be used
if [ "x$DST_REPO" == "x$DEFAULT_DST_REPO" ]; then
	dst_repo_addr=$DEFAULT_DST_REPO
elif [ "x$DST_REPO" == "x" ]; then
	dst_repo_addr=$DEFAULT_DST_REPO
else
	dst_repo_addr=$DST_REPO
fi
echo "Destination repo address: $dst_repo_addr"

PLATFORM_BRANCH="platform-branch"
WIRELESS_BRANCH="wireless-branch"
MASTER="master"
# default platform and wireless remote address
PLATFORM_REMOTE="platform_remote"
WIRELESS_REMOTE="wireless_remote"

current_branch=`git branch | grep "\*" | awk '{print $2}'`
echo "Current branch: $current_branch"

echo "Save current branch status"
git stash

echo "Add platform and wireless remote address"
git remote add $PLATFORM_REMOTE $src_repo_addr
git remote add $WIRELESS_REMOTE $dst_repo_addr

echo "Fetch '$PLATFORM_REMOTE' and '$WIRELESS_REMOTE'"
git fetch $PLATFORM_REMOTE
git fetch $WIRELESS_REMOTE

echo "Create and switch to a new branch '$WIRELESS_BRANCH' from '$WIRELESS_REMOTE:$MASTER'"
git checkout -b $WIRELESS_BRANCH $WIRELESS_REMOTE/$MASTER

echo "Merge all new platform commits to '$WIRELESS_BRANCH'"
git merge --no-ff -m "Merge all new commits to current wireless master branch" $PLATFORM_REMOTE/$MASTER

# Waiting for user input Yes or No, Yes will do push thing, otherwise exit
OPTION_YES="Yes"
OPTION_NO="No"
echo "--------Note!!!----------"
echo "You will push changes merged to server, please double confirm(Yes or No) "
read user_command
if [ "x$user_command" == "x$OPTION_YES" ]; then
	# Now script will push changes merged
	echo "Push changes to '$WIRELESS_REMOTE:$MASTER'"
	git push $WIRELESS_REMOTE $WIRELESS_BRANCH:$MASTER
else
	echo "No push anything."
fi

echo "Checkout branch back to '$current_branch'"
git checkout $current_branch

echo "Pop branch '$current_branch' status"
git stash pop

echo "Delete '$WIRELESS_BRANCH' branch"
git branch -D $WIRELESS_BRANCH

echo "Delete '$PLATFORM_REMOTE' and '$WIRELESS_REMOTE' remote"
git remote remove $PLATFORM_REMOTE
git remote remove $WIRELESS_REMOTE

echo "Merge finished."
echo "$SCRIPT_NAME stop."





