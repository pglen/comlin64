Name: beesu
Version: 2.7
Release: 1%{?dist}
Summary: Bee's installer script for beesu
URL: http://www.honeybeenet.altervista.org
Group: Applications/System
License: GPLv2+
Source0: http://spot.fedorapeople.org/%{name}/%{name}-%{version}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: pam, usermode

%description
Beesu is a wrapper around su and works with consolehelper under
Fedora to let you have a graphic interface like gksu.

%prep
%setup -q

%build
make CFLAGS="%{optflags}"

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_datadir}/%{name}

make DESTDIR=%{buildroot} install

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%doc COPYING README
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/%{name}.conf
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/pam.d/%{name}
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/security/console.apps/%{name}
%{_sysconfdir}/profile.d/%{name}-bash-completion.sh
%{_sbindir}/%{name}
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1.gz

%changelog
* Thu Jun 22 2010 Bee <http://www.honeybeenet.altervista.org> 2.7-1
- Update to 2.7

* Fri Jun 18 2010 Bee <http://www.honeybeenet.altervista.org> 2.6-1
- Update to 2.6

* Wed Jul 22 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.4-1
- Update to 2.4

* Mon Mar 30 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.3-1
- Update to 2.3

* Fri Feb 13 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.2-1
- Update to 2.2, adds bash auto completion feature

* Thu Jan 29 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.1-1
- slight package cleanup from Bee

* Fri Nov 28 2008 Bee <http://www.honeybeenet.altervista.org> 2.0-1
- new RPMs for Fedora 10 and some source clean up.

* Mon Oct 27 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-3
- new RPMs

* Wed Oct 15 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-2
- package needs to be arch specific , patch so rpm builds in mock or as non-root & clean up

* Mon Oct 13 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-1
- initial release
