#! /usr/bin/bash
set -uvx
set -e
cwd=`pwd`
ts=`date "+%Y.%m%d.%H%M"`
version="${ts//.0/.}"

echo $version

pubspec-gen "$version"
#dart pub get

cat << EOS >> CHANGELOG.md

## $version

- pubspec.yaml was generated using pubspec-gen
EOS

dos2unix pubspec.yaml
dos2unix CHANGELOG.md

./do-analyze.sh
./do-test.sh

tag="$version"
git add .
git commit -m"$tag"
git tag -a "$tag" -m"$tag"
git push origin "$tag"
git push origin HEAD:main
git remote -v

dart pub publish --force
