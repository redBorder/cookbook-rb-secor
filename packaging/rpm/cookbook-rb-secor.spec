Name: cookbook-rb-secor
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: Secor service to store kafka data and send to s3

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-rb-secor
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/secor
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/secor/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/secor
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/secor/README.md

%pre

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload secor'
  ;;
esac

%files
%defattr(0755,root,root)
/var/chef/cookbooks/secor
%defattr(0644,root,root)
/var/chef/cookbooks/secor/README.md

%doc

%changelog
* Tue Jan 21 2025 Miguel Álvarez <arodriguez@redborder.com> - 0.0.1
- first spec version
