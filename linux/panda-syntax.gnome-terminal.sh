#! /bin/sh

echo Loading Panda Syntax ubuntu terminal profile
dconf load /org/gnome/terminal/legacy/profiles:/ <<EOF
[/]
list=['619f29ad-4a95-4b60-bab2-1206f0092b88']

[:619f29ad-4a95-4b60-bab2-1206f0092b88]
background-color='rgb(37,40,42)'
bold-color='rgb(117,116,116)'
bold-color-same-as-fg=false
cursor-background-color='rgb(111,118,130)'
cursor-colors-set=true
cursor-foreground-color='rgb(248,248,248)'
font='Source Code Pro 13'
foreground-color='rgb(243,243,243)'
highlight-background-color='rgb(117,116,116)'
highlight-colors-set=true
highlight-foreground-color='rgb(230,230,230)'
palette=['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']
scrollback-lines=15000
use-system-font=false
use-theme-colors=false
visible-name='panda'
EOF
