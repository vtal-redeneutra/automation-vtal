*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/141_ConsultarViabilidadeEndereco.xlsx


*** Test Cases ***
141.01 - Validar Disponibilidade Fibra e Complemento - Netwin
    Consultar Viabilidade Netwin