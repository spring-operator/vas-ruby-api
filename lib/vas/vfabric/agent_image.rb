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


module VFabric

  # Provides access to the installation image for the vFabric Administration Agent
  class AgentImage < Shared::Resource

    # @private
    def initialize(location, client)
      super(location, client)
      @content_location = Util::LinkUtils.get_link_href(details, "content")
    end

    # Retrieves the content of the agent installation image (a zip file) from the server
    #
    # @yield [chunk] a chunk of the agent image's content
    #
    # @return [void]
    def content(&block)
      client.get_stream(@content_location, &block)
    end

    # Downloads and extracts the agent installation image
    #
    # @param location [String] the location to extract the agent to
    #
    # @return [void]
    def extract_to(location = '.')
      Tempfile.open('agent-image.zip') { |temp_file|
        content { |chunk| temp_file << chunk }
        temp_file.rewind
        Zip::ZipFile.foreach(temp_file.path) { |entry|
          FileUtils.mkdir_p(File.dirname(entry.name))
          entry.extract
        }
        temp_file.rewind
        Zip::ZipFile.foreach(temp_file.path) { |entry|
          File.chmod(entry.unix_perms, entry.name)
        }
        temp_file.delete
      }

      File.join(location, 'vfabric-administration-agent')
    end
  end

end