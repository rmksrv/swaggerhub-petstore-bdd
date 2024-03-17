import json

import requests
from behave import step

ROOT_URL = r"https://petstore.swagger.io/v2"


@step('I make POST request to "{path}" with body')
def make_post_request_step(context, path):
    body = json.loads(context.text or "{}")
    url = ROOT_URL + path
    context.response = requests.post(url, json=body)
    assert True


@step("Response is {status_code:d}")
def assert_response_step(context, status_code):
    assert context.response.status_code == status_code, f"Expected {status_code}, got {context.response.status_code}"


def has_json_response(context) -> bool:
    try:
        context.response.json()
        return True
    except ValueError or AttributeError:
        return False


@step("Response contains json with items")
def assert_response_contains_json(context):
    assert has_json_response(context), f"Expected json, but got {context.response.text}"
    actual_values = context.response.json()
    expected_values = json.loads(context.text)
    for field in expected_values:
        expected_value = expected_values[field]
        actual_value = actual_values[field]
        match expected_value:
            case "<{any_int}>":
                assert isinstance(actual_value, int), f'Expected "{field}" is a number value, got {actual_value}'
            case _:
                assert expected_value == actual_value, f'Expected "{field}" equals {expected_value}, got {actual_value}'
