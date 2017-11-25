### Project

<details>
<summary> click here </summary>
<p>


- GET /api/project/?\<params>

    This method gets projects from DB. If you doesn't put any parameter, so will return all.
    - Parameters:
        - project_id (optional): the id of a project that is a positive integer not null (e.g. 1, 2, 3, ...).
        - user_id (optional): the id of a user that is a positive integer not null (e.g. 1, 2, 3, ...).
    - Examples:
         - Get all projects: http://localhost:8888/api/project/
         - Get one project by id: http://localhost:8888/api/project/?project_id=1001
         - Get projects by user id: http://localhost:8888/api/project/?user_id=1001
    - Send:
    - Response: a JSON that contain the features selected. Example:
        ```javascript
        {
            'features': [
                {
                    'type': 'Project',
                    'tags': [{'k': 'name', 'v': 'default'},
                             {'k': 'description', 'v': 'default project'}],
                    'properties': {'removed_at': None, 'fk_user_id_owner': 1001,
                                   'id': 1001, 'create_at': '2017-10-20 00:00:00'}
                }
            ],
            'type': 'FeatureCollection'
        }
        ```
    - Error codes:
        - 400 (Bad Request): Invalid parameter.
        - 404 (Not Found): Not found any feature.
        - 500 (Internal Server Error): Problem when get a project. Please, contact the administrator.
    - Notes:

- PUT /api/project/create

    This method create a new project described in a JSON.
    - Parameters:
    - Examples:
         - Create a feature: ```PUT http://localhost:8888/api/project/create```
    - Send: a JSON describing the feature. Example:
        ```javascript
        {
            'project': {
                'tags': [{'k': 'created_by', 'v': 'test_api'},
                         {'k': 'name', 'v': 'project of data'},
                         {'k': 'description', 'v': 'description of the project'}],
                'properties': {'id': -1}
            }
        }
        ```
    - Response: a JSON that contain the id of the feature created. Example:
        ```javascript
        {'id': 7}
        ```
    - Error codes:
        - 403 (Forbidden): It is necessary a user logged in to access this URL.
        - 500 (Internal Server Error): Problem when create a project. Please, contact the administrator.
    - Notes: The key "id", when send a JSON, is indifferent. It is just there to know where the key "id" have to be.

<!-- - PUT /api/project/update -->

- DELETE /api/project/delete/#id

    This method delete one project by id = #id.
    - Parameters:
        - #id (mandatory): the id of the feature that is a positive integer not null (e.g. 1, 2, 3, ...).
    - Examples:
         - Delete a feature by id: ```DELETE http://localhost:8888/api/project/7```
    - Send:
    - Response:
    - Error codes:
        - 400 (Bad Request): Invalid parameter.
        - 403 (Forbidden): It is necessary a user logged in to access this URL.
        - 404 (Not Found): Not found any feature.
        - 500 (Internal Server Error): Problem when delete a project. Please, contact the administrator.
    - Notes:


</p>
</details>