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

require 'spec_helper'
require 'component_helper'
require 'java_buildpack/container/tomcat/tomcat_http_connector'

describe JavaBuildpack::Container::TomcatHttpConnector do
  include_context 'component_helper'

  let(:component_id) { 'tomcat' }

  context do

    let(:configuration) do
      { 'maxThreads'        =>  200,
        'minSpareThreads'   =>  10,
        'acceptCount'       =>  100,
        'connectionTimeout' =>  60_000,
        'keepAliveTimeout'  =>  60_000,
        'maxConnections'    =>  10_000 }
    end

    it 'set given configuration options',
       app_fixture:   'container_tomcat_http_connector' do

      component.compile

      expect((sandbox + 'conf/server.xml').read)
        .to eq(Pathname.new('spec/fixtures/container_tomcat_http_connector_server_after.xml').read)
    end
  end

  context do

    it 'set default values',
       app_fixture:   'container_tomcat_http_connector' do

      component.compile

      expect((sandbox + 'conf/server.xml').read)
        .to eq(Pathname.new('spec/fixtures/container_tomcat_http_connector_defaults_server_after.xml').read)
    end
  end
end
