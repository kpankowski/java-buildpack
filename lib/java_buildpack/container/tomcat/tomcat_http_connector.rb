# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/container'
require 'java_buildpack/container/tomcat/tomcat_utils'
require 'java_buildpack/logging/logger_factory'

module JavaBuildpack
  module Container

    # Encapsulates the detect, compile, and release functionality for Tomcat Redis support.
    class TomcatHttpConnector < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Container

      # (see JavaBuildpack::Component::BaseComponent#detect)
      def detect
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        mutate_server
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
      end

      private

      # Standard server.xml that ships with Tomcat sets connectionTimeout to 20000 (20sec)
      CONNECTION_TIMEOUT = 20_000.freeze

      private_constant :CONNECTION_TIMEOUT

      def mutate_server
        document = read_xml server_xml
        connector   = REXML::XPath.first(document, 'Server/Service/Connector[@protocol=\'HTTP/1.1\' or not(@protocol)]')

        add_connector_configuration connector
        write_xml server_xml, document
      end

      def add_connector_configuration(connector)
        connector.add_attributes 'maxThreads'         =>  @configuration['maxThreads'],
                                 'minSpareThreads'    =>  @configuration['minSpareThreads'],
                                 'acceptCount'        =>  @configuration['acceptCount'],
                                 'connectionTimeout'  =>  @configuration['connectionTimeout'] || CONNECTION_TIMEOUT,
                                 'keepAliveTimeout'   =>  @configuration['keepAliveTimeout'],
                                 'maxConnections'     =>  @configuration['maxConnections']
      end
    end

  end
end
