# -------------------------------------------------------------------------
#
# SPDX-FileCopyrightText: Copyright (c) 2024 Contributors to 
# the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http: *www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-FileType: SOURCE
# SPDX-License-Identifier: Apache-2.0
#
# -------------------------------------------------------------------------

Feature: Testing Publish and Subscribe Functionality

  Scenario Outline: To test the registerlistener and send apis
    Given "<uE1>" creates data for "registerlistener"
    And sets "entity.name" to "body.access"
    And sets "entity.id" to "12345"
    And sets "entity.version_major" to "1"
    And sets "resource.name" to "door"
    And sets "resource.id" to "12345"
    And sets "resource.instance" to "front_left"
    And sets "resource.message" to "Door"

    When sends "registerlistener" request
    Then the status received with "code" is "OK"

    When "<uE2>" creates data for "send"
    And sets "attributes.id.msb" to "112128268635242497"
    And sets "attributes.id.lsb" to "11155833020022798372"
    And sets "attributes.source.entity.name" to "body.access"
    And sets "attributes.source.entity.id" to "12345"
    And sets "attributes.source.entity.version_major" to "1"
    And sets "attributes.source.resource.name" to "door"
    And sets "attributes.source.resource.id" to "12345"
    And sets "attributes.source.resource.instance" to "front_left"
    And sets "attributes.source.resource.message" to "Door"
    And sets "attributes.priority" to "UPRIORITY_CS1"
    And sets "attributes.type" to "UMESSAGE_TYPE_PUBLISH"
    And sets "payload.format" to "UPAYLOAD_FORMAT_PROTOBUF_WRAPPED_IN_ANY"
    And sets "payload.value" to b".type.googleapis.com/google.protobuf.Int32Value\x12\x02\x08\x03"
    And sends "send" request

    Then the status received with "code" is "OK"
      And "<uE1>" sends onreceive message with field "payload.value" as b"type.googleapis.com/google.protobuf.Int32Value\x12\x02\x08\x03"

    # Unregister in the end for cleanup
    When "<uE1>" creates data for "unregisterlistener"
      And sets "entity.name" to "body.access"
      And sets "entity.id" to "12345"
      And sets "entity.version_major" to "1"
      And sets "resource.name" to "door"
      And sets "resource.id" to "12345"
      And sets "resource.instance" to "front_left"
      And sets "resource.message" to "Door"
      And sends "unregisterlistener" request

    Then the status received with "code" is "OK"

    Examples:
      | uE1    | uE2    |
      | rust   | rust   |
      | rust   | python |
      | python | rust   |
      | rust   | java   |
      | java   | rust   |
      | python | python |
      | java   | java   |
      | java   | python |
      | python | java   |