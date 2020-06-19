@api @provisioning_api-app-required @skipOnLDAP @skipOnOcis
Feature: create a subadmin
  As an admin
  I want to be able to make a user the subadmin of a group
  So that I can give administrative privilege of a group to a user

  Background:
    Given using the OCS API version defined externally

  @smokeTest
  Scenario: admin creates a subadmin
    Given user "brand-new-user" has been created with default attributes and skeleton files
    And group "brand-new-group" has been created
    When the administrator makes user "brand-new-user" a subadmin of group "brand-new-group" using the provisioning API
    Then the OCS status code should be "100" for OCS API version 1 or "200" for OCS API version 2
    And the HTTP status code should be "200"
    And user "brand-new-user" should be a subadmin of group "brand-new-group"

  Scenario: admin tries to create a subadmin using a user which does not exist
    Given user "nonexistentuser" has been deleted
    And group "brand-new-group" has been created
    When the administrator makes user "nonexistentuser" a subadmin of group "brand-new-group" using the provisioning API
    Then the OCS status code should be "101" for OCS API version 1 or "400" for OCS API version 2
    And the HTTP status code should be "200" for OCS API version 1 or "400" for OCS API version 2
    And user "nonexistentuser" should not be a subadmin of group "brand-new-group"

  Scenario: admin tries to create a subadmin using a group which does not exist
    Given user "brand-new-user" has been created with default attributes and skeleton files
    And group "not-group" has been deleted
    When the administrator makes user "brand-new-user" a subadmin of group "not-group" using the provisioning API
    Then the OCS status code should be "102" for OCS API version 1 or "400" for OCS API version 2
    And the HTTP status code should be "200" for OCS API version 1 or "400" for OCS API version 2
    And the API should not return any data

  @issue-31276
  Scenario: subadmin of a group tries to make another user subadmin of their group
    Given these users have been created with default attributes and skeleton files:
      | username       |
      | subadmin       |
      | brand-new-user |
    And group "brand-new-group" has been created
    And user "subadmin" has been made a subadmin of group "brand-new-group"
    And user "brand-new-user" has been added to group "brand-new-group"
    When user "subadmin" makes user "brand-new-user" a subadmin of group "brand-new-group" using the provisioning API
    Then the OCS status code should be "997"
    #Then the OCS status code should be "997" for OCS API version 1 or "400" for OCS API version 2
    And the HTTP status code should be "401"
    And user "brand-new-user" should not be a subadmin of group "brand-new-group"