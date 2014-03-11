#!/bin/bash

bundle exec rake assets:precompile
git add .
version=(`grep v0 app/views/zaehlers/grafik.html.erb | awk '{print $4}'`)
echo "commit message: $version"
read msg
git commit -am "$version: $msg"
git push
