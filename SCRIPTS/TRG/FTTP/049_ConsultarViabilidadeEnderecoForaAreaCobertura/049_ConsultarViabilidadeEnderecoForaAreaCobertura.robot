*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/049_ConsultarViabilidadeEnderecoForaAreaCobertura.xlsx


*** Test Cases ***

49.01 - Gerar token de acesso
    Retornar Token Vtal

49.02/03 - Realiza consulta de Logradouro
    Consulta Id Logradouro com Id Complements

49.03/04 - Realiza consulta de viabilidade
    Viabilidade Fora de Cobertura           true

        


    
    
   