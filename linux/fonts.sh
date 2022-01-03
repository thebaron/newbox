#! /usr/bin/sh


echo Installing fonts...

FONTS=

mkdir -p ${HOME}/.local/share/fonts

rm -Rf font-tmp && mkdir -p font-tmp
for f in SF-Fourche.zip \
	 TTF-source-code-pro-2.038R-ro-1.058R-it.zip; do
   unzip -d font-tmp ../$f
done

cp -v $(find font-tmp -name \*ttf) ${HOME}/.local/share/fonts
rm -Rf font-tmp

fc-cache -fv  ${HOME}/.local/share/fonts/


