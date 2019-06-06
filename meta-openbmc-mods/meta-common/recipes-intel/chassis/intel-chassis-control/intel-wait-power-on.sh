#!/bin/bash

# Copyright 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

echo "wait for pgood = ON"
SERVICE=$(mapper get-service /xyz/openbmc_project/Chassis/Control/Power0)
PGOOD=$(busctl get-property $SERVICE \
        /xyz/openbmc_project/Chassis/Control/Power0 xyz.openbmc_project.Chassis.Control.Power pgood \
        | sed 's/i\s*[1]/on/' | grep on | wc -l)

while [ $PGOOD == 0 ]; do
  echo "!ON"
sleep 1
PGOOD=$(busctl get-property $SERVICE \
        /xyz/openbmc_project/Chassis/Control/Power0 xyz.openbmc_project.Chassis.Control.Power pgood \
        | sed 's/i\s*[1]/on/' | grep on | wc -l)
done
echo "pgood = ON"