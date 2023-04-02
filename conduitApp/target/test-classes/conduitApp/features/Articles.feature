
Feature: Test for the articles page

Background: Define url
    * url apiUrl
    * def articleRequest = read('classpath:conduitApp/requestFiles/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequest.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequest.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequest.article.body = dataGenerator.getRandomArticleValues().body

Scenario: Create and delete article
    Given path 'articles'
    And request articleRequest
    When method POST
    Then status 200
    And match response.article.title == articleRequest.article.title
    # Se define la variable para identificar el slug del artículo creado para después borrarlo
    * def articleid = response.article.slug

    # Se listan los artículos creados y se agarra el primero del arreglo que es el último creado
    Given params {limit:10,offset:0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == articleRequest.article.title

    # Se hace delete al artículo mediante el slug
    Given path 'articles',articleid
    When method DELETE
    Then status 204
    
    # Se vuelve a lista los artículos creados para validar que ya no existe el artículo eliminado
    Given params {limit:10,offset:0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != articleRequest.article.title