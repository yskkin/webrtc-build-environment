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
