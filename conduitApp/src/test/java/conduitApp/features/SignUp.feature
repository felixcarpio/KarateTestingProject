
Feature: Sign Up scenarios

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def ramdomUsername = dataGenerator.getRandomUsername()
    Given url apiUrl


Scenario: New user created
    Given path 'users'
    And request
    """
        {
            "user": {
                "email": #(randomEmail),
                "password": "karateuser789",
                "username": #(ramdomUsername)
            }
        }
    """
    When method POST
    Then status 200
    And match response ==
    """
        {
            "user": {
                "email": #(randomEmail),
                "username": #(ramdomUsername),
                "bio": null,
                "image": "#string",
                "token": "#string"
            }
        }
    """

Scenario Outline: New user created
    Given path 'users'
    And request
    """
        {
            "user": {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
            }
        }
    """
    When method POST
    Then status 422
    And match response == <errorResponse>

    Examples:
        | email                | password  | username          | errorResponse                                        |
        | #(randomEmail)       | Karate123 | Lifemiles1        | {"errors": {"username":["has already been taken"]}}  |
        | Lifemiles1@gmail.com | Karate123 | #(ramdomUsername) | {"errors": {"email":["has already been taken"]}}     |
        | #(randomEmail)       | Karate123 |                   | {"errors": {"username":["can't be blank"]}}          |
        |                      | Karate123 | #(ramdomUsername) | {"errors": {"email":["can't be blank"]}}             |
