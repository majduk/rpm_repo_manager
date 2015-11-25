Private RPM Repository manager. The manager creates yum repo on the same server, in `/var/www/html/repo`

# Installation

Install dependencies:
```
yum install createrepo
yum install rpm-build
```
Inpack scripts to ~/

# Management
 In order to add an RPM to the repo:

1) create RPM Spec in ~/specs

2) put sources in ~/sources (unless you user github)

3) edit ~/tools/build_list.txt and insert data about package

4) run ~/tools/build_all.sh

5) run ~/tools/update_repo.sh 
