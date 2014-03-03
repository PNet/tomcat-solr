default[:tomcat][:user][:username] = "admin"
default[:tomcat][:user][:password] = "4dm1n"

default[:solr][:version]     = "4.7.0"
default[:solr][:url]         = "http://mirror.sdunix.com/apache/lucene/solr/#{node[:solr][:version]}/solr-#{node[:solr][:version]}.tgz"
default[:solr][:unpack_path] = "/tmp/solr-#{node[:solr][:version]}"
