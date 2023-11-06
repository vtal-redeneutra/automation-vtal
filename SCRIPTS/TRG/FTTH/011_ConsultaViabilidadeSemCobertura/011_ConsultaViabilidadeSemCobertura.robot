*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/011_ConsultaViabilidadeSemCobertura.xlsx


*** Test Cases ***
11.01 - Gerar Token de Acesso
    Retornar Token Vtal

11.02-03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro com Id Complements

11.04 - Realizar Consulta de Viabilidade
    Viabilidade Fora de Cobertura

11.04 - Validar Notificação Consulta de Viabilidade via FW Console 
    Validar Evento FW                       VALOR_BUSCA=idComplements
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ResourcePoolManagement.AvailabilityCheck.v2'])[1]
    ...                                     RETORNO_ESPERADO=>401<