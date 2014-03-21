#
# Cookbook Name:: scm
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(git git-svn subversion).each do |scm|
  package scm do
    action :install
  end
end

git "/opt/depot_tool" do
  repository "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
  action :checkout
end

bash "export path" do
  rc_file = "~vagrant/.bashrc"
  export = "export PATH=$PATH:/opt/depot_tool"

  user "vagrant"
  code "echo '#{export}' >> #{rc_file}"
  not_if "grep '#{export}' #{rc_file}"
end
