#set -x
. repo_config.cfg
package_name=$1
package_source=$2
source_data=$3

if [ ! -n "$package_source" ];then
        package_source=github
fi

if [ "$package_source" == "github" ];then
        if [ ! -n "$source_data" ];then
                echo "Missing GitHub user name"
                exit 1
        fi
fi

rpm_root=$RPMROOT
repo_root=$REPODIR
sources_root=$SOURCES
specs_root=$SPECS

test -f ${specs_root}/${package_name}.spec || { echo "Missing spec $spec_file"; exit; }

spec_file=$rpm_root/SPECS/$package_name.spec
cp ${specs_root}/${package_name}.spec ${spec_file}

VERSION=$( grep -i 'version:' $spec_file | awk '{ print $2 }'    )
RELEASE=$( grep -i 'release:' $spec_file | awk '{ print $2 }'    )
NAME=$( grep -i 'name:' $spec_file | awk '{ print $2 }'    )
ARCH=$( grep -i 'BuildArch:' $spec_file | awk '{ print $2 }'    )

test -n "$NAME" ||  { echo "Missing Name in $spec_file"; exit; }
test -n "$RELEASE" ||  { echo "Missing Release in $spec_file"; exit; }
test -n "$VERSION" ||  { echo "Missing Version in $spec_file"; exit; }

PWD=$( pwd )
cd $rpm_root
if [ ! -d tmp ];then
        mkdir tmp
fi
localname="${NAME}-${VERSION}.tar.gz"
case "$package_source" in
"github")
        remotename="v${VERSION}.tar.gz"
        wget --output-document tmp/$localname "https://github.com/${source_data}/${NAME}/archive/$remotename"
        test -f tmp/$localname || { echo "Download failed"; exit 1; }
        ;;
"localdir")
        cd $sources_root
        localdir="${NAME}-${VERSION}"
        if [ -d ${localdir} ];then
                if [ ! -f $rpm_root/SOURCES/"${localname}" ];then
                        tar -czvf $rpm_root/tmp/"${localname}" ${localdir}/
                else
                        list=$( find ${localdir} -type f -newer $rpm_root/SOURCES/"${localname}" )
                        if [ -n "$list" ];then
                                tar -czvf $rpm_root/tmp/"${localname}" ${localdir}/
                        else
                                echo "No files were modified in sources"
                                exit
                        fi
                fi
        else
                echo "$localdir not found in $sources_root"
                exit 1
        fi
        cd $rpm_root
        ;;
*)
        echo "Undefined package source $package_source"
        exit 1;
        ;;
esac

if [ -f "RPMS/${ARCH}/${NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm" ];then
                if [ -f SOURCES/$localname ];then
                        oldfile=$( md5sum  SOURCES/$localname | awk '{ print $1 }' )
                        newfile=$( md5sum  tmp/$localname | awk '{ print $1 }' )
                        if [ "$oldfile" == "$newfile" ]; then
                                rm -rf tmp/$localname
                                { echo "Source is not updated"; exit; }
                        fi
                fi
fi
mv tmp/$localname SOURCES/


rpmbuild -ba $spec_file
test -f RPMS/${ARCH}/${NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm || { echo "Build failed"; exit; }
test -d $repo_root && cp RPMS/${ARCH}/${NAME}-${VERSION}-${RELEASE}.${ARCH}.rpm $repo_root/
cd $PWD
