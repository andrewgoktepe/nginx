#
# Cookbook Name:: nginx
# Recipes:: ngx_ldap_module
#
# Author:: Andrew Goktepe (<andrewgoktepe@gmail.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node["platform_family"]
when 'debian'
  package 'libldap2-dev' do
    action :install
  end
when 'rhel'
  package 'libldap2-devel' do
    action :install
  end
end

git "#{Chef::Config[:file_cache_path]}/nginx-auth-ldap" do
  repository node['nginx']['ldap']['url']
  revision   node['nginx']['ldap']['revision']
  action :sync
end

node.run_state['nginx_configure_flags'] =
  node.run_state['nginx_configure_flags'] | ["--add-module=#{Chef::Config[:file_cache_path]}/nginx-auth-ldap"]

