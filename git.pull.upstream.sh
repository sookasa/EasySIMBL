#!/bin/bash -
#=======================================================================
#
#   DESCRIPTION: Pull upstream code
#  REQUIREMENTS: git
#       COMPANY: Sookasa Inc.
#      REVISION: 1.0
#=======================================================================

SCRIPT=`basename $0`
DIR=`dirname $0`
USAGE="Usage: $0 [upstream-url]"
EXAMPLE="Example: $0 https://github.com/sookasa/upstream"

# default configuration
url=https://github.com/norio-nomura/EasySIMBL
name=upstream
branch=master

# process input
if [ $# -gt 1 ]; then
    echo $USAGE "(default $url)"
    echo $EXAMPLE
    exit 1
fi

if [ $# == 1 ]; then
    url=$1
fi

# check prerequisites
which -s git || { echo "-E- git not found"; exit 1; }

# remove previous configuration
_url=`git remote -v | grep ^$name | grep \(fetch\)$ | awk '{print $2}' 2>&1`
git remote remove $name &> /dev/null && \
    { echo  "-I- Removed exisitng $_url"; }

# add new remote branch as upstream
git remote add $name $url && \
    { echo "-I- Added $name => $url"; } || \
    { echo "-E- Failed to add: $url"; exit 2; }

# pull it, and report result
echo "-I- Pulling $url $branch:"
git pull $name $branch
rc=$? && test $rc -eq 0 && echo "-I- Pulled successfully" || echo "-E- Failed!"

# handover (git pull) result
exit $rc
