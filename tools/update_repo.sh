#!/usr/bin/env bash

. repo_config.cfg

if [ ! -d $DATADIR ];then
        mkdir -p $DATADIR
fi

ls -l -1 --time-style=+%s $RPMSDIR/* > $DATADIR/files.tmp

#any differences in file list?
diff $DATADIR/files.tmp $DATADIR/files >> /dev/null 2>&1
if [ $? -ne 0 ];then
        date
        find  $RPMSDIR -type f -name '*.rpm' -exec cp {} $REPODIR \;
        createrepo --update $REPODIR
        cp $DATADIR/files.tmp $DATADIR/files
(
cat << EOD
<html>
<body>
<a href="repo-release-1.noarch.rpm">repo-release-1.noarch.rpm</a>
</body>
</html>
EOD
) > $REPODIR/index.html
else
        echo "No files were update in the repo"
fi
