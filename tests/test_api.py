#!/usr/bin/env python
# -*- coding: utf-8 -*-


from unittest import TestCase
from json import loads, dumps
from requests import get, Session


class TestAPI(TestCase):

    def test_get_api_create_changeset_without_login(self):
        # do a GET call
        response = get('http://localhost:8888/api/changeset/create/')

        self.assertEqual(response.status_code, 403)

        expected = {'status': 403, 'statusText': 'It needs a user looged to access this URL'}
        resulted = loads(response.text)  # convert string to dict/JSON

        self.assertEqual(expected, resulted)

    def test_get_api_create_changeset_with_login(self):
        # create a session, simulating a browser. It is necessary to create cookies on server
        s = Session()

        ################################################################################
        # DO LOGIN
        ################################################################################

        response = s.get('http://localhost:8888/auth/login/fake/')

        self.assertEqual(response.status_code, 200)

        ################################################################################
        # CREATE A CHANGESET
        ################################################################################

        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}

        # send a JSON with the changeset to create a new one
        changeset = {
            "plc": {
                'changeset': {
                    'tags': [{'k': 'created_by', 'v': 'test_api'},
                             {'k': 'comment', 'v': 'testing create changeset'}],
                    'properties': {'id': -1, "fk_project_id": 1001}
                }
            }
        }

        # do a GET call, sending a changeset to add in DB
        response = s.get('http://localhost:8888/api/changeset/create/', data=dumps(changeset), headers=headers)

        resulted = loads(response.text)  # convert string to dict/JSON

        self.assertIn("id", resulted)
        self.assertNotEqual(resulted["id"], -1)

        # put the id received in the original JSON of changeset
        changeset["plc"]["changeset"]["properties"]["id"] = resulted["id"]




        ################################################################################
        # CLOSE THE CHANGESET
        ################################################################################

        id_changeset = changeset["plc"]["changeset"]["properties"]["id"]

        response = s.get('http://localhost:8888/api/changeset/close/{0}'.format(id_changeset))

        self.assertEqual(response.status_code, 200)

        ################################################################################
        # DO LOGOUT
        ################################################################################

        response = s.get('http://localhost:8888/auth/logout')

        self.assertEqual(response.status_code, 200)

        ################################################################################
        # TRY TO CREATE ANOTHER CHANGESET WITHOUT LOGIN
        ################################################################################

        # do a GET call, sending a changeset to add in DB
        response = s.get('http://localhost:8888/api/changeset/create/', data=dumps(changeset), headers=headers)

        # it is not possible to create a changeset without login, so get a 403 Forbidden
        self.assertEqual(response.status_code, 403)







# It is not necessary to pyt the main() of unittest here,
# because this file will be call by run_tests.py
