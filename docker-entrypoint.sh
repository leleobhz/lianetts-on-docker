#!/bin/bash

set -eo pipefail
shopt -s nullglob

_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_main() {
	# if command starts with an option, prepend mysqld
	if [ "${1:0:1}" = '-' ]; then
		set -- lianetts "$@"
	else
		set -- lianetts -h
	fi

	exec "$@"
}

if ! _is_sourced; then
	_main "$@"
fi

