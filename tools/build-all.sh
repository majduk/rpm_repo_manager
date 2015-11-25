cat build-list.txt | while read package source data; do

echo "Building package $package"
$( dirname $0 )/build-rpm.sh "$package" "$source" "$data"

done
