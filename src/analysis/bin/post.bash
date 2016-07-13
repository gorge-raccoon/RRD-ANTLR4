#!/usr/bin/env bash

# get build filename
BIN=$(mvn help:evaluate -Dexpression=project.build.finalName | grep -vi info)

# moving data
git checkout master
mv target/site /tmp
mv target/$BIN /tmp


# Executable Build with Update Binary Branch
git checkout binary-master
mv -f circle.yml /tmp
mv -f .gitignore /tmp
git checkout master
git push origin :binary-master
git branch -D binary-master
git checkout --orphan binary-master
rm -Rf *
mv -f /tmp/.gitignore .
mv -f /tmp/circle.yml .
mv /tmp/$BIN .
git add --all .
git commit -m "binaries master branch"
git push origin binary-master


# Documentation Build with Update to GH-Pages Branch
git checkout gh-pages
mv -f circle.yml /tmp
mv -f .gitignore /tmp
git checkout master
git push origin :gh-pages
git branch -D gh-pages
git checkout --orphan gh-pages
rm -Rf *
mv -f /tmp/.gitignore .
mv -f /tmp/circle.yml .
mv /tmp/site/* .
git add --all .
git commit -m "current documentation"
git push origin gh-pages

