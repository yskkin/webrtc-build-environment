#
# Cookbook Name:: scm
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
