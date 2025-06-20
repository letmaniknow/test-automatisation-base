Feature: Test Marvel Characters API

  Background:
    * configure ssl = true
    * url baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Get all characters
    Given url baseUrl + '/testuser/api/characters'
    When method GET
    Then status 200
    * print response