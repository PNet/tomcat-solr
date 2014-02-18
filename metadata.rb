name		          "tomcat-solr"
maintainer        "The Amazing DevTeam"
maintainer_email  "dev@archdaily.com"
license           "Apache 2.0"
description       "Installs and configures tomcat 7 and solr 4"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
recipe            "tomcat-solr", "Installs and configure tomcat and solr to use them in production"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "java::oracle"
