*** Settings ***

Library                                     Process    
Library                                     JSONLibrary
Library                                     OperatingSystem
Library                                     String
Library                                     Collections


*** Test Cases ***


Concatenar JSON
    Concatenar JSON




*** Keywords ***


Concatenar JSON

    ${JSON_FINAL}=	                        Load Json From File	                    C:/IBM_VTAL/DOCUMENTATION/JSON/RES_API.json
    Copy File                               C:/IBM_VTAL/DOCUMENTATION/JSON/RES_API.json                                     C:/IBM_VTAL/DOCUMENTATION/Final.json     
    Remove File                             C:/IBM_VTAL/DOCUMENTATION/JSON/RES_API.json


    ${ARQUIVOS} =	                        List Files In Directory	                ${CURDIR}/JSON                          *.json

    FOR    ${ARQUIVO}    IN    @{ARQUIVOS}
        ${JSON}=	                        Load Json From File	                    C:/IBM_VTAL/DOCUMENTATION/JSON/${ARQUIVO}
        @{KEYWORDS}=                        Get Value From Json                     ${JSON}                                 $.keywords[*]
        FOR    ${KEYWORD}    IN    @{KEYWORDS}
            ${JSON_FINAL}=                  Add Object To Json                      ${JSON_FINAL}                           $.keywords                              ${KEYWORD}
        END
    END
    
    ${FINAL_STRING}=                        Convert Json To String                  ${JSON_FINAL}
    Create File                             C:/IBM_VTAL/DOCUMENTATION/Final.json    ${FINAL_STRING}
    Remove Directory                        C:/IBM_VTAL/DOCUMENTATION/JSON          recursive=True
                   
