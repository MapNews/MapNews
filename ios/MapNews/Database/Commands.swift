//
//  Commands.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct Commands {
    static let createTableString =
    """
    CREATE TABLE IF NOT EXISTS COUNTRIES(
    COUNTRY_CODE STRING,
    LAT DOUBLE,
    LONG DOUBLE,
    NAME STRING);
    """

    static let queryCountryStatementString =
    """
    SELECT LAT, LONG FROM COUNTRIES
    WHERE NAME = ?;
    """

    static let queryCountryCoordinateDTOStatementString =
    """
    SELECT COUNTRY_CODE, NAME, LAT, LONG FROM COUNTRIES
    """

    static let insertStatementString =
    """
    INSERT INTO COUNTRIES (COUNTRY_CODE, LAT, LONG, NAME) VALUES (?, ?, ?, ?);
    """

    static let queryCountriesStatementString =
    """
    SELECT NAME FROM COUNTRIES
    ORDER BY NAME
    """
}
