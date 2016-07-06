#!/bin/bash
# idea borrowed from https://github.com/kadirahq/mantra/blob/master/resources/push-to-gh-pages.sh

# cleanup dist directory
rm -rf dist || exit 0;
mkdir dist;

# build static web site
npm run build

# move to dist directory
cd dist

# publish content on gh
git init

# create a fake commit
git add .
git commit -m "Deploy to GitHub Pages"

git config user.name 'GH Pages Bot'
git config user.email 'mstn@noreplay.github.com'

git push --force --quiet "git@github.com:mstn/graphql.git" master:gh-pages > /dev/null 2>&1
