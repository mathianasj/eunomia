#!/usr/bin/env bash

# Copyright 2019 Kohl's Department Stores, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o nounset
set -o errexit

function pullFromTemplatesRepo {
  set +u
  if [ ! -z "$TEMPLATE_GIT_HTTP_PROXY" ] 
  then
    http_proxy=$TEMPLATE_GIT_HTTP_PROXY
  fi
  if [ ! -z "$TEMPLATE_GIT_HTTPS_PROXY" ] 
  then
    https_proxy=$TEMPLATE_GIT_HTTPS_PROXY
  fi 
  if [ ! -z "$TEMPLATE_GIT_NO_PROXY" ] 
  then
    no_proxy=$TEMPLATE_GIT_NO_PROXY
  fi
  if [ -n "$TEMPLATE_GITCONFIG" ] && [ -d "$TEMPLATE_GITCONFIG" ]
  then
    for file in $TEMPLATE_GITCONFIG/*; do
      if [ -e "$file" ]
      then
        cp -f $file ~/$(basename $file)
      fi
    done
    for file in $TEMPLATE_GITCONFIG/.git*; do
      if [ -e "$file" ]
      then
        cp -f $file ~/$(basename $file)
      fi
    done      
  else
   export GIT_SSL_NO_VERIFY=true
  fi 
  set -u
  mkdir -p $TEMPLATE_GIT_DIR
  git clone -b $TEMPLATE_GIT_REF $TEMPLATE_GIT_URI $TEMPLATE_GIT_DIR
}

function pullFromParametersRepo {
  set +u
  if [ ! -z "$PARAMETER_GIT_HTTP_PROXY" ] 
  then
    http_proxy=$PARAMETER_GIT_HTTP_PROXY
  fi
  if [ ! -z "$PARAMETER_GIT_HTTPS_PROXY" ] 
  then
    https_proxy=$PARAMETER_GIT_HTTPS_PROXY
  fi 
  if [ ! -z "$PARAMETER_GIT_NO_PROXY" ] 
  then
    no_proxy=$PARAMETER_GIT_NO_PROXY
  fi
  if [ -z "$PARAMETER_GITCONFIG" ] && [ -d "$PARAMETER_GITCONFIG" ]
  then 
    for file in $TEMPLATE_GITCONFIG/*; do
      cp -f $file ~/$(basename $file)
    done
    for file in $TEMPLATE_GITCONFIG/.git*; do
      cp -f $file ~/$(basename $file)
    done    
  else
   export GIT_SSL_NO_VERIFY=true
  fi    
  set -u
  mkdir -p $PARAMETER_GIT_DIR
  git clone -b $PARAMETER_GIT_REF $PARAMETER_GIT_URI $PARAMETER_GIT_DIR
}

echo Cloning Repositories
pullFromTemplatesRepo
pullFromParametersRepo
mkdir -p $MANIFEST_DIR
