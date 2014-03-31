#
# Cookbook Name:: webrtc
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
directory node['webrtc']['source_root'] do
  owner "vagrant"
  action :create
end

bash "gclient config" do
  user "vagrant"
  cwd node["webrtc"]["source_root"]
  code <<-CODE
    /opt/depot_tool/gclient config http://webrtc.googlecode.com/svn/trunk
  CODE
  creates "#{node['webrtc']['source_root']}/.gclient"
end

bash "modify target os" do
  target_os = 'target_os = ["android", "unix"]'

  user "vagrant"
  code "echo '#{target_os}' >> #{node['webrtc']['source_root']}/.gclient"
  not_if "grep '#{target_os}' #{node['webrtc']['source_root']}/.gclient"
end

bash "gclient sync" do
  user "vagrant"
  cwd node["webrtc"]["source_root"]
  code <<-CODE
    /opt/depot_tool/gclient sync --nohooks
  CODE
end

bash "install build deps" do
  cwd node["webrtc"]["source_root"]
  code <<-CODE
    source trunk/build/install-build-deps.sh --no-prompt --no-chromeos-fonts
    source trunk/build/install-build-deps-android.sh
  CODE
end

build_deps = %w(
  fakeroot
  build-essential pkg-config
  python2.7-dev
  gcc g++ g++-multilib
  bison flex
  gperf
  libnss3-dev
  libasound2-dev
  libgconf2-dev
  libglib2.0-dev
  libgnome-keyring-dev
  libgtk2.0-dev
  libnspr4-0d libnspr4-dev
  freetype-dev
  libcairo2-dev
  libcupsys2-dev
  libdbus-1-dev
  libbz2-dev libzip2-dev
  libjpeg62-dev
  libpam0g-dev
  libexpat-dev
  mesa-common-dev
  libgl1-mesa-dev libglu1-mesa-dev
  libxss-dev
  libxtst-dev
  libcurl4-gnutls-dev
  libelf-dev
  libpci-dev
  libpulse-dev

  libc6-i386
  lib32stdc++6
)

android_build_deps = %w(
  checkstyle
  lighttpd
  python-pexpect
  xvfb
  x11-utils
  lib32z1
  ant
)

(build_deps + android_build_deps).each do |dep|
  package dep do
    # For now, use install-build-deps*.sh
    action :nothing
  end
end

bash "runhooks" do
  user "vagrant"
  code <<-CODE
    source #{node['webrtc']['source_root']}/trunk/build/android/envsetup.sh
    /opt/depot_tool/gclient runhooks
    android_gyp
  CODE
  returns [0, 1]
end
