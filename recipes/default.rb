include_recipe "java::oracle"

%w{ libtomcat7-java tomcat7-common tomcat7-user tomcat7-docs tomcat7-admin tomcat7 }.each do |package_name|
  package package_name do
    action :install
  end
end

# configure tomcat users
template "/etc/tomcat7/tomcat-users.xml" do
  source "tomcat-users.xml.erb"
  owner "root"
  group "tomcat7"
  mode "775"
end

remote_file "/tmp/apache-solr-#{node[:solr][:version]}.tgz" do
  source node[:solr][:url]
  mode "755"
  action :create_if_missing
end

# bash unpack solr
bash 'unpack solr' do
  user 'root'
  cwd '/tmp'
  code "tar -xzvf apache-solr-#{node[:solr][:version]}.tgz"
  not_if "test -d #{node[:solr][:unpack_path]}"
end

bash "install solr on tomcat" do
  user "root"
  cwd node[:solr][:unpack_path]
  code <<-EOH
    cp -f dist/solr-#{node[:solr][:version]}.war /var/lib/tomcat7/webapps/solr.war
    cp -Rf example/solr/ /var/lib/tomcat7/solr/
  EOH
  # TODO: not if case
end

# copy the solr config
cookbook_file "/var/lib/tomcat7/conf/Catalina/localhost/solr.xml" do
  cookbook "tomcat-solr"
  source "solr.xml"
  owner "root"
  group "root"
  mode 0775
end

directory "/var/lib/tomcat7/solr/data" do
  owner "tomcat7"
  group "tomcat7"
  mode "0755"
  action :create
end

# give the respective permissions
bash "install solr on tomcat" do
  user "root"
  code <<-EOH
    chown -R tomcat7:tomcat7 /var/lib/tomcat7/
    chmod 775 /var/lib/tomcat7/conf/tomcat-users.xml
    service tomcat7 restart
  EOH
end
