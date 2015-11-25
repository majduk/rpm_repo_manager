Name: bashir
Version: 1.23
Release: 1
Summary: Bash scripting framework base
Source:  %{name}-%{version}.tar.gz
License: GPL
Group: Bashir/Base
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: bash >= 3.1, vixie-cron
Requires(pre): /usr/sbin/useradd, /usr/bin/getent
Requires(postun): /usr/sbin/userdel
%description
The package contains some good practice based scripts grouped into a framework simplifying creating BASH based applications.
%prep
%setup
%build
%install
install -m 0755 -d $RPM_BUILD_ROOT/home/p4app/COMMON
install -m 0755 -d $RPM_BUILD_ROOT/home/p4app/COMMON/{lock,log}
for dir in bin etc lib;do
        install -m 0700 -d $RPM_BUILD_ROOT/home/p4app/COMMON/$dir
        install -m 0700 COMMON/$dir/* $RPM_BUILD_ROOT/home/p4app/COMMON/$dir/
done
install -m 0600 .bash_logout $RPM_BUILD_ROOT/home/p4app/.bash_logout
install -m 0600 .lesshst $RPM_BUILD_ROOT/home/p4app/.lesshst
install -m 0600 .bash_profile $RPM_BUILD_ROOT/home/p4app/.bash_profile
%clean
rm -rf $RPM_BUILD_ROOT
%pre
/usr/bin/getent group p4app > /dev/null   || /usr/sbin/groupadd -r p4app
/usr/bin/getent passwd p4app  > /dev/null || /usr/sbin/useradd -r -m -g p4app -d /home/p4app -s /bin/bash p4app
%post
chown -R p4app:p4app /home/p4app
{ echo -e 'MAILTO=""\nFRAMEWORK_COMMON=/home/p4app/COMMON\n* * * * * bash  $FRAMEWORK_COMMON/bin/env.sh'; } | crontab -u p4app -
%postun
/usr/bin/getent passwd p4app  > /dev/null && /usr/sbin/userdel -r p4app
%files
/home/p4app/.bash_logout
/home/p4app/.lesshst
%config /home/p4app/.bash_profile
%dir /home/p4app/COMMON
/home/p4app/COMMON/bin
%config /home/p4app/COMMON/etc
/home/p4app/COMMON/lib
/home/p4app/COMMON/lock
/home/p4app/COMMON/log

