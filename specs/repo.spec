Name: repo
Version: release
Release: 1
Summary: Michal Ajduks RPM repository configuration
Source:  %{name}-%{version}.tar.gz
License: GPL
Group: System Environment/Base
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: yum
%description
This package contains yum configuration for the private RPM Repository.
%prep
%setup
%build
%install
install -m 0755 -d $RPM_BUILD_ROOT/etc/yum.repos.d
install -m 0644 ajduk.repo $RPM_BUILD_ROOT/etc/yum.repos.d/ajduk.repo
%clean
rm -rf $RPM_BUILD_ROOT
%pre
%post
%postun
%files
/etc/yum.repos.d/ajduk.repo
