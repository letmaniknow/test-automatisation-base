@REQ_TEST-101 @testMarvel
Feature: Test Marvel Characters API

  Background:
    * configure ssl = true
    * def username = 'letmaniknow1'
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

  @getCharacterByIdNotFound
  Scenario: Get all characters
    Given url baseUrl + '/' + username + '/api/characters/99999999'
    When method GET
    Then status 404

  @updateCharacter
  Scenario: Actualizar personaje existente (PUT)
    * def newCharacter = read('classpath:../data/Marvel/newCharacter.json')
    * def randomNumber = Math.floor(Math.random() * 10000) + 1
    And newCharacter.name = newCharacter.name + randomNumber
    Given request newCharacter
    When method post
    Then status 201
    * def Id = response.id
    * def updatedCharacter1 = read('classpath:../data/Marvel/updatedCharacter.json')
    Given path Id
    And request updatedCharacter1
    When method put
    Then status 200
    And match response.name == "Hulk new"

  @updateCharacterNotExist
  Scenario: Actualizar personaje inexistente (PUT)
    * def notFoundCharacter = read('classpath:../data/Marvel/notFoundCharacter.json')
    Given path 9999
    And request notFoundCharacter
    When method put
    Then status 404

  @DeleteCharacter
  Scenario: Eliminar personaje existente (DELETE)
    * def deletedCharacter = read('classpath:../data/Marvel/deletedCharacter.json')
    Given request deletedCharacter
    When method post
    Then status 201
    * def thorId = response.id

    Given path thorId
    When method delete
    Then status 204

  @DeleteCharacterNotExist
  Scenario: Eliminar personaje inexistente (DELETE)
    Given path 9999
    When method delete
    Then status 404

