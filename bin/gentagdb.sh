#!/bin/bash

HERE=${PWD}

DIR=${1:-"${HERE}"}

CSCOPE_FILES="${HERE}/cscope"

if [[ ! -d ${CSCOPE_FILES} ]]; then
  mkdir "${CSCOPE_FILES}"
fi

blacklist() {
    cat << EOF
refs.*build\|\
padtec.*build\|\
build.*padtec\|\
trd.*build
EOF
}

use_blacklist() {
  echo -n > "${CSCOPE_FILES}"/cscope.files
  while read list; do
    if [ x${1} == xno ]; then
        echo ${list} >> "${CSCOPE_FILES}"/cscope.files
    else
        echo ${list} | grep -v "$(blacklist)" >> "${CSCOPE_FILES}"/cscope.files
    fi
  done
}

find "$DIR" -name "*.c" -o \
-name "*.cc" -o \
-name "*.cpp" -o \
-name "*.h" -o \
-name "*.hh" -o \
-name "*.hpp" \
-type f | xargs realpath | $(use_blacklist ${2})

cd "${CSCOPE_FILES}"
cscope -q -R -b -k
ctags -L 'cscope.files'
cd "${DIR}"
