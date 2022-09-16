#!/usr/bin/env python
# -*- coding: utf-8 -*-


############################################################
# POSTGRESQL
############################################################

# A dictionary with the settings about connection
__PGSQL_CONNECTION_SETTINGS__ = {
    "HOSTNAME": "pauliceia_postgis",
    "USERNAME": "postgres",
    "PASSWORD": "postgres",
    "DATABASE": "pauliceia",
    "PORT": 5432
}

# A dictionary with the settings about Test/Debug connection
__DEBUG_PGSQL_CONNECTION_SETTINGS__ = {
    "HOSTNAME": "pauliceia_postgis",
    "USERNAME": "postgres",
    "PASSWORD": "postgres",
    "DATABASE": "pauliceia_test",
    "PORT": 5432
}


############################################################
# GEOSERVER
############################################################

# A dictionary with the settings about connection
__GEOSERVER_CONNECTION_SETTINGS__ = {
    "HOSTNAME": "",
    "PORT": 0,
    "WORKSPACE": "",
    "DATASTORE": "",
}

# A dictionary with the settings about Test/Debug connection
__DEBUG_GEOSERVER_CONNECTION_SETTINGS__ = {
    "HOSTNAME": "localhost",
    "PORT": 8080,
    "WORKSPACE": "",
    "DATASTORE": "",
}


############################################################
# GEOSERVER-REST
############################################################

# A dictionary with the settings about connection
__GEOSERVER_REST_CONNECTION_SETTINGS__ = {
    "HOSTNAME": "",
    "PORT": 0,
}
