Feature: Everything about your Pets
  As user I want to add, update, and delete pets in the pet store

  Scenario: I successfully create new empty pet
    When I make POST request to "/pet" with body
    Then Response is 200
     And Response contains json with items
      """
      {
        "id": "<{any_int}>",
        "tags": [],
        "photoUrls": []
      }
      """


  Scenario Outline: I successfully create new pet with specified name, category, status, tags and photo
    When I make POST request to "/pet" with body
      """
      {
        "name": "Barsik",
        "category": {"name": "cats"},
        "status": "<category>",
        "tags": [
          {"name": "puffy"},
          {"name": "young"}
        ]
      }
      """
    Then Response is 200
     And Response contains json with items
      """
      {
        "id": "<{any_int}>",
        "name": "Barsik",
        "category": {"id": 0, "name": "cats"},
        "status": "<category>",
        "tags": [
          {"id": 0, "name": "puffy"},
          {"id": 0, "name": "young"}
        ],
        "photoUrls": []
      }
      """
    Examples:
      | category  |
      | available |
      | pending   |
      | sold      |


  @negative
  Scenario: I get an error if I try to create a pet with invalid category id
    When I make POST request to "/pet" with body
      """
      {
        "category": {"id": "zero", "name": "cats"}
      }
      """
    Then Response is 500


  @negative
  Scenario: I get an error if I try to create a pet with invalid tag id
    When I make POST request to "/pet" with body
      """
      {
        "tags": {"id": "zero", "name": "puffy"}
      }
      """
    Then Response is 500

