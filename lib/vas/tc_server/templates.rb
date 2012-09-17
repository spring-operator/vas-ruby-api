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

  # Used to enumerate, create, and delete tc Server templates.
  class Templates < Shared::MutableCollection
    
    # @private
    def initialize(location, client)
      super(location, client, "templates", Template)
    end
    
    # Creates a new template
    #
    # @param template_image [TemplateImage] the template image to use to create the template
    #
    # @return [Template] the new template
    def create(template_image)
      Template.new(client.post(location, { :image => template_image.location }, "template"), client)
    end
    
  end
  
  # A tc Server template
  class Template < Shared::Resource

    # @return [String] the template's version
    attr_reader :version
    
    # @return [String] the template's name
    attr_reader :name

    # @return [TemplateImage] the template image, if any, that this template was created from
    attr_reader :template_image

    # @return [Installation] the template's installation
    attr_reader :installation

    # @private
    def initialize(location, client)
      super(location, client)

      @version = details["version"]
      @name = details["name"]
      @installation = Installation.new(Util::LinkUtils.get_link_href(details, 'installation'), client)

      template_image_location = Util::LinkUtils.get_link_href(details, "template-image")
      @template_image = TemplateImage.new(template_image_location, client) unless template_image_location.nil?
    end

    # @return [String] a string representation of the template
    def to_s
      "#<#{self.class} name='#@name' version='#@version'>"
    end
    
  end
  
end