#!/usr/bin/env bash
scp -o "ProxyCommand=nc -X connect -x tur-cache.massey.ac.nz:8080 %h %p" "$@"
