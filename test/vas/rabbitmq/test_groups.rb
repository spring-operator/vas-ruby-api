#--
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
#++

module Rabbit

  class TestGroups < VasTestCase

    def test_list
      groups = Groups.new(
          "https://localhost:8443/rabbitmq/v1/groups/",
          StubClient.new)
      assert_count(2, groups)

      assert_equal('https://localhost:8443/vfabric/v1/security/2/', groups.security.location)
    end

    def test_create
      location = "https://localhost:8443/rabbitmq/v1/groups/"

      client = StubClient.new

      group_location = "https://localhost:8443/rabbitmq/v1/groups/2/"

      node1_location = "https://localhost:8443/rabbitmq/v1/nodes/1/"
      node2_location = "https://localhost:8443/rabbitmq/v1/nodes/2/"

      client.expect(:post, group_location, [location, {:name => "test-group", :nodes => [node1_location, node2_location]}, "group"])

      node1 = create_mock_with_location(node1_location)
      node2 = create_mock_with_location(node2_location)

      assert_equal(group_location, Groups.new(location, client).create("test-group", [node1, node2]).location)
    end

    def test_group
      group = Group.new("https://localhost:8443/rabbitmq/v1/groups/2/", StubClient.new)

      assert_equal("https://localhost:8443/rabbitmq/v1/groups/2/installations/", group.installations.location)
      assert_equal("https://localhost:8443/rabbitmq/v1/groups/2/instances/", group.instances.location)
      assert_equal("https://localhost:8443/vfabric/v1/security/3/", group.security.location)

      assert_equal(2, group.nodes.size)
      assert_equal("https://localhost:8443/rabbitmq/v1/nodes/1/", group.nodes[0].location)
      assert_equal("https://localhost:8443/rabbitmq/v1/nodes/0/", group.nodes[1].location)
    end

    def test_delete
      client = StubClient.new
      groups = Groups.new("https://localhost:8443/rabbitmq/v1/groups/", client)

      group_location = "https://localhost:8443/rabbitmq/v1/groups/2/"
      client.expect(:delete, nil, [group_location])

      groups.delete(Group.new(group_location, client))

      client.verify
    end

  end
end
