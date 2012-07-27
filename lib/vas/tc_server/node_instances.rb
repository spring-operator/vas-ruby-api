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

  # Used to enumerate tc Server instances on an individual node
  class NodeInstances < Shared::NodeInstances

    def initialize(location, client) #:nodoc:
      super(location, client, "node-instances", NodeInstance)
    end

  end

  # A tc Server node instance
  class NodeInstance < Shared::NodeInstance
    
    # The instance's layout
    attr_reader :layout
    
    # The version of runtime used by the instance
    attr_reader :runtime_version
    
    # The instance's services
    attr_reader :services

    # The instance's NodeApplications
    attr_reader :applications

    def initialize(location, client) #:nodoc:
      super(location, client, Node, Logs, Instance, 'group-instance')

      @layout = details["layout"]
      @runtime_version = details["runtime-version"]
      @services = details["services"]
      @applications = NodeApplications.new(Util::LinkUtils.get_link_href(details, "node-applications"), client)
    end

  end

end