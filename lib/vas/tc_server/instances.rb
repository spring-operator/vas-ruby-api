# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module TcServer

  # Used to enumerate, create, and delete tc Server instances.
  class Instances < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "group-instances", Instance)
    end

    # Creates a new instance named +name+, using the Installation +installation+.
    # Creation can be customized using +options+.
    #
    # Recognized options are:
    #
    # properties::      A hash of properties
    # runtime_version:: The version of the runtime to be used by the instance.
    #                   Must be one of the runtime_versions available in the Installation.
    #                   Defaults to the latest available version.
    # templates::       An array of templates to use when creating the instance. Each Template
    #                   must be present in the Installation.
    # layout::          The layout to use when creating the instance. Valid values are +COMBINED+
    #                   and +SEPARATE+. Defaults to +SEPARATE+.
    def create(installation, name, options = {})
      payload = { :installation => installation.location, :name => name }
      
      if options.has_key?(:properties)
        payload[:properties] = options[:properties]
      end
      
      if options.has_key?(:runtime_version)
        payload["runtime-version"] = options[:runtime_version]
      end
      
      if options.has_key?(:templates)
        template_locations = []
        options[:templates].each { |template| template_locations << template.location }
        payload[:templates] = template_locations
      end
      
      if options.has_key?(:layout)
        payload[:layout] = options[:layout]
      end
      
      Instance.new(client.post(location, payload, "group-instance"), client)
    end

  end

  # A tc Server instance
  class Instance < Shared::Instance
    
    # The instance's layout
    attr_reader :layout
    
    # The version of runtime used by the instance
    attr_reader :runtime_version
    
    # The instance's services
    attr_reader :services

    # The instance's Applications
    attr_reader :applications

    def initialize(location, client) #:nodoc:
      super(location, client, Group, Installation, LiveConfigurations, PendingConfigurations, NodeInstance, 'node-instance')

      @layout = details["layout"]
      @runtime_version = details["runtime-version"]
      @services = details["services"]
      @applications = Applications.new(Util::LinkUtils.get_link_href(details, "group-applications"), client)

    end

    # Updates the instance to use the given +installation+ and, optionally, to use the given +runtime_version+
    def update(installation, runtime_version = nil)
      payload = { :installation => installation.location }
      if (!runtime_version.nil?)
        payload['runtime-version'] = runtime_version
      end
      client.post(location, payload);
    end

  end

end