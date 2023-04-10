Feature: Test for the home page

Background: Define url
    Given url apiUrl

Scenario: Get all tags
    Given path 'tags'
    When method GET
    Then status 200
    And match response.tags contains ['welcome','introduction']
    And match response.tags !contains 'truck'
    And match response.tags contains any ['cupiditate','implementations']
    And match response.tags == "#array"
    And match each response.tags == "#string"

Scenario: Get 10 articles from the page
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given params {limit:10,offset:0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles == '#[10]'
    And match response == { "articles": "#array", "articlesCount": 201}
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": null,
                "image": "#string",
                "following": "#boolean"
            }
        }
    """