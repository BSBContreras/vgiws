#!/usr/bin/env python
# -*- coding: utf-8 -*-


def is_a_invalid_id(feature_id):
    """
    Verify if the id of some feature is valid or not.
    For a id to be valid, it needs to be:
        (1) not None; (2) a integer (a digit); (3) if is a integer, so different of 0.
    IDs are integer numbers greater than zero.
    :param feature_id: id of a feature in string format.
    :return: if id is invalid, return True, else False
    """

    # if the id is None it is 'valid', because I can receive a None id, so it is not used
    if feature_id is None:
        return False

    # if the id is not string, so it is invalid
    if not isinstance(feature_id, str):
        return True

    # if the id is "NULL" it is "valid", because I can receive a "NULL" id to search
    if feature_id == "NULL":
        return False

    # if feature_id is not a digit, so it is invalid
    if not feature_id.isdigit():
        return True

    # if feature_id is digit and is 0, so it is invalid
    if (feature_id.isdigit()) and (feature_id == "0"):
        return True

    # so it is VALID
    return False

    # # if feature_id is None or is not a digit, so it is invalid
    # if (feature_id is None) or (not feature_id.isdigit()):
    #     return True
    #
    # # if feature_id is digit and is 0, so it is invalid
    # if (feature_id.isdigit()) and (feature_id == "0"):
    #     return True
    #
    # # so it is VALID
    # return False

    # return (feature_id is not None and not feature_id.isdigit()) or \
    #        (feature_id is not None and feature_id.isdigit() and feature_id == "0")


def are_arguments_valid_to_get_elements(**arguments):
    # the ids are just valid if there are numbers
    if "element_id" in arguments and is_a_invalid_id(arguments["element_id"]):
        return False
    elif "layer_id" in arguments and is_a_invalid_id(arguments["layer_id"]):
        return False
    elif "changeset_id" in arguments and is_a_invalid_id(arguments["changeset_id"]):
        return False
    else:
        return True
