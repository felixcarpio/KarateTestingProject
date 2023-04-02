@debug
Feature: Home Work

Background: Preconditions
    * url apiUrl 
    * def timeValidator = read('classpath:helpers/timeValidator.js')

Scenario: Favorite articl
    # Get the list of all articles and get the last one.
    Given params {limit:1,offset:0}
    Given path 'articles'
    When method GET
    Then status 200

    # Save the slug id and favorite count.
    * def slugid = response.articles[0].slug
    * def favsCount = response.articles[0].favoritesCount

    # Call the endpoint to favorte and specific article.
    Given path 'articles',slugid,'favorite'
    And request {}
    When method POST
    Then status 200

    # Validate the schema of favorited article and verify the slug id and favorite count.
    And match response ==
    """
        {
            "article": {
                "id": '#number',
                "slug": #(slugid),
                "title": '#string',
                "description": '#string',
                "body": '#string',
                "createdAt": '#? timeValidator(_)',
                "updatedAt": '#? timeValidator(_)',
                "authorId": '#number',
                "tagList": [],
                "author": {
                    "username": '#string',
                    "bio": null,
                    "image": '#string',
                    "following": '#boolean'
                },
                "favoritedBy": [
                    {
                        "id": '#number',
                        "email": '#string',
                        "username": '#string',
                        "password": '#string',
                        "image": '#string',
                        "bio": null,
                        "demo": '#boolean'
                    }
                ],
                "favorited": true,
                "favoritesCount": #(favsCount + 1)
            }
        }
    """

    # Get all the favorited articles of an user.
    Given params {favorited:Lifemiles1,limit:10}
    Given path 'articles'
    When method GET
    Then status 200

    # Validate the schema and verify that favorited count has increased by 1.
    And match response.articles[0] ==
    """
        {
            "slug": #(slugid),
            "title": '#string',
            "description": '#string',
            "body": '#string',
            "tagList": [],
            "createdAt": '#? timeValidator(_)',
            "updatedAt": '#? timeValidator(_)',
            "favorited": true,
            "favoritesCount": #(favsCount + 1),
            "author": {
                "username": '#string',
                "bio": null,
                "image": '#string',
                "following": '#boolean'
            }
        }
    """


Scenario: Comment articles
    # Get the last item of the list of artciles of user.
    Given params {limit:1,offset:0}
    Given path 'articles'
    When method GET
    Then status 200

    # Save the slug id and favorites count of the last article.
    * def slugid = response.articles[0].slug

    # Call the endpoint to list all comments.
    Given path 'articles',slugid,'comments'
    When method GET
    Then status 200

    # Create the variable to save the length of the array of comments list.
    * def initialCount = response.comments.length
    
    # Print the number of comments.
    Then print 'count now is ',initialCount

    # Validate the schema of the response.
    And match each response.comments ==
    """
        {
            "id": '#number',
            "createdAt": '#? timeValidator(_)',
            "updatedAt": '#? timeValidator(_)',
            "body": '#string',
            "author": {
                "username": '#string',
                "bio": null,
                "image": '#string',
                "following": '#boolean'
            }
        }
    """

    # Call the endpoint to publish the comment, declare a variable to parameter the comment body.
    * def commentBody = "Este es un comentario"
    Given path 'articles',slugid,'comments'
    And request 
    """
        {
            "comment": {
                "body": #(commentBody)
            }
        }
    """
    When method POST
    Then status 200

    # Validate the schema of the response and verify the body of the comment to be the same of request.
    And match response ==
    """
        {
            "comment": {
                "id": '#number',
                "createdAt": '#? timeValidator(_)',
                "updatedAt": '#? timeValidator(_)',
                "body": #(commentBody),
                "author": {
                    "username": '#string',
                    "bio": null,
                    "image": '#string',
                    "following": false
                }
            }
        }
    """

    # Save the comment id to use it on delete scenario.
    * def commentid = response.comment.id
    Then print 'id is ',commentid 

    # Call the endpoint to list all comments.
    Given path 'articles',slugid,'comments'
    When method GET
    Then status 200

    # Validate the length of comments array again to catch the number.
    * def commentsCount = response.comments.length
    Then print 'count now is ',commentsCount

    # Validate the comments count increased by 1.
    And match commentsCount == initialCount+1

    # Call the endpoint to delete the comment and send the parameter of comment id.
    Given path 'articles',slugid,'comments',commentid
    When method DELETE
    Then status 200

    # List the comments of article again
    Given path 'articles',slugid,'comments'
    When method GET
    Then status 200

    # Get the count of comments again and validate that has decreased by 1 after delete.
    * def commentsCount = response.comments.length
    Then print 'count now is ',commentsCount
    And match commentsCount == initialCount