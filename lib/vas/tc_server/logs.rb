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

  # Used to enumerate a tc Server node instance's logs
  class Logs < Shared::Logs

    # @private
    def initialize(location, client)
      super(location, client, Log)
    end

  end

  # A log file in a tc Server node instance
  class Log < Shared::Log

    # @private
    def initialize(location, client)
      super(location, client, 'node-instance', NodeInstance)
    end

  end

end