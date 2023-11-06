*** Settings ***
Documentation                               Validar Complemento no FSL
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/FSL/UTILS.robot

*** Variables ***



*** Keywords ***


Validar Complemento FSL
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para logar no FSL, consultar a SA com o objetivo de validar se existe o complemento no FSL.

    Logar no FSL
    Consultar SA
    Validar Complemento

#===========================================================================================================================================================================================================
Validar Complemento
    [Documentation]                         ValidarComplementoFSL
    ...                                     \n Função usada para logar no FSL, consultar a SA com o objetivo de validar se existe o complemento no FSL.

    [Tags]                                  ValidarComplementoFSL
    
    ${tipo_comp}=                           Get Text Element is Visible             ${span_tipo_complemento}
    ${abrev_comp}=                          Get Text Element is Visible             ${span_abreviacao_complemento}

    Scroll To Element                       ${span_tipo_complemento}      
    Highlight Elements                      ${span_tipo_complemento}                duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                 
    
    Scroll To Element                       ${span_abreviacao_complemento}      
    Highlight Elements                      ${span_abreviacao_complemento}          duration=500ms                          width=4px                               color=\#dd00dd                          style=solid
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}     
    
    Log  ${tipo_comp}   console=True
    Log  ${abrev_comp}   console=True

    IF  "${tipo_comp}" == "" or "${abrev_comp}" == ""
        Fatal Error                         \nComplemento não está preenchido!
    END

    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
