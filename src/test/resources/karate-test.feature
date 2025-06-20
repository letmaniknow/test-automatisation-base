@REQ_TEST-101 @testMarvel
Feature: Test Marvel Characters API

  Background:
    * configure ssl = true
    * def username = 'letmaniknow'
    * url baseUrl + '/' + username + '/api/characters'

  @getAllCharacters
  Scenario: Get all characters
    When method GET
    Then status 200
    * print response
    And match response == '#[]'

  @createNewCharacter
  Scenario: Crear personaje válido
    * def randomNumber = Math.floor(Math.random() * 10000) + 1
    * def newCharacter = read('classpath:../data/Marvel/newCharacter.json')
    And newCharacter.name = newCharacter.name + randomNumber
    Given request newCharacter
    When method post
    Then status 201

  @createNewCharacterWithError
  Scenario: Error al crear personaje duplicado
    * def newCharacter = read('classpath:../data/Marvel/newCharacter.json')
    Given request newCharacter
    When method post
    Then status 400

  @createNewCharacterDataInvalid
  Scenario: Error al crear personaje data invalida
    * def newCharacter = read('classpath:../data/Marvel/newCharacter.json')
    And newCharacter.name = ""
    And newCharacter.alterego = ""
    And newCharacter.description = ""
    And newCharacter.powers = []
    Given request newCharacter
    When method post
    Then status 400

  @getCharacterById
  Scenario: Obtener personaje por ID existente
    * def randomNumber = Math.floor(Math.random() * 10000) + 1
    * def newCharacter = read('classpath:../data/Marvel/newCharacter.json')
    And newCharacter.name = newCharacter.name + randomNumber
    Given request newCharacter
    When method post
    Then status 201
    * def createdId = response.id

    Given path createdId
    When method get
    Then status 200


