//
//  Commands.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct Commands {
    static let createCoordinatesTableString =
    """
    CREATE TABLE IF NOT EXISTS COORDINATES(
    COUNTRY_CODE STRING,
    LAT DOUBLE,
    LONG DOUBLE);
    """

    static let createNamesTableString =
    """
    CREATE TABLE IF NOT EXISTS NAMES(
    COUNTRY_CODE STRING,
    NAME STRING);
    """

    static let createConfigTableString =
    """
    CREATE TABLE IF NOT EXISTS HOME(
    NAME STRING
    )
    """

    static let queryCountryStatementString =
    """
    SELECT c.LAT, c.LONG FROM COORDINATES c
    INNER JOIN NAMES n ON n.COUNTRY_CODE = c.COUNTRY_CODE
    WHERE n.NAME = ?;
    """

    static let queryAllCountryCoordinateDTOStatementString =
    """
    SELECT c.COUNTRY_CODE, n.NAME, c.LAT, c.LONG FROM COORDINATES c
    INNER JOIN NAMES n ON n.COUNTRY_CODE = c.COUNTRY_CODE
    """

    static let queryDefaultLocationString =
    """
    SELECT NAME FROM HOME;
    """

    static let insertCoordinatesStatementString =
    """
    INSERT INTO COORDINATES (COUNTRY_CODE, LAT, LONG) VALUES (?, ?, ?);
    """

    static let insertNamesStatementString =
    """
    INSERT INTO NAMES (COUNTRY_CODE, NAME) VALUES (?, ?);
    """

    static let queryCountriesStatementString =
    """
    SELECT NAME FROM NAMES
    ORDER BY NAME
    """

    static let countCommandString =
    """
    SELECT COUNT(*) FROM COORDINATES
    """

    static let queryCountryCoordinateDTOStatementString =
    """
    SELECT c.COUNTRY_CODE, c.LAT, c.LONG FROM COORDINATES c
    INNER JOIN NAMES n ON n.COUNTRY_CODE = c.COUNTRY_CODE
    WHERE n.NAME = ?;
    """

    static let deleteDefaultLocationString =
    """
    DELETE * IN HOME;
    """

    static let insertDefaultLocationString =
    """
    INSERT INTO HOME (NAME) VALUES (?)
    """
}
