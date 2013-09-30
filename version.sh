#!/bin/sh

#  version.sh
#  Rook
#
#  Created by Matthieu on 2013-09-30.
#  Copyright (c) 2013 Matthieu. All rights reserved.

git=/usr/bin/git
version=$($git describe --tags `$git rev-list --tags --max-count=1`)
latest_commit=$($git rev-parse HEAD)
echo $version
echo $latest_commit
/usr/libexec/PlistBuddy -c "Set :Revision $version" Rook/Rook-Info.plist
/usr/libexec/PlistBuddy -c "Set :Commit $latest_commit" Rook/Rook-Info.plist