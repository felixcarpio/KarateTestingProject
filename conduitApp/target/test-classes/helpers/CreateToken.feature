Feature: Create token feature

Scenario: Create a token
    Given url apiUrl
    Given path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method POST
    Then status 200
    * def authToken = response.user.token