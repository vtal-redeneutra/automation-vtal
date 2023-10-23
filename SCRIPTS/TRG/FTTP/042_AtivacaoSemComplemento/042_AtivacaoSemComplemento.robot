*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference
...                                         OUPUT: Appointment_Start, Work_Order_Id, SOM_Order_Id, MaxBandWidth, Associated_Document, Correlation_Order, Associated_Document_Date, Name, Catalog_Id, Availability_Description, Inventory_Id, Type_Logradouro, Address_Name, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3 
    



Resource                                     ../../../../DATABASE/ROB/DB.robot
Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot   
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              C:/IBM_VTAL/DATA/TRG_FTTP_DAT_042_AtivacaoSemComplemento.xlsx


*** Test Cases ***

42.01 - Gerar Token de Acesso 
    [TAGS]                                  COMPLETO    42_01_Gerar_Token_de_Acesso 
    Inicia CT
    Criar Tabela Execucao                   ${RESPONSAVEL}
    Retornar Token Vtal
    Fecha CT  API  42_02_03_Realizar_consulta_de_Logradouro

42.02 e 03 - Realizar consulta de Logradouro
    [TAGS]                                  COMPLETO    42_02_03_Realizar_consulta_de_Logradouro 
    Inicia CT
    Retornar Token Vtal
    Consulta Id Logradouro                  UF=BAHIA        Municipio=SALVADOR     
    Fecha CT  API  42_04_05_Realizar_consulta_de_Complemento_e_consulta_de_viabilidade

42.04 e 05 - Realizar consulta de Complemento e Realizar consulta de viabilidade
    [TAGS]                                  COMPLETO    42_04_05_Realizar_consulta_de_Complemento_e_consulta_de_viabilidade
    Inicia CT
    Retornar Token Vtal
    Retorna Viabilidade dos Produtos
    Fecha CT  API  42_06_Realizar_a_Criacao_de_Ordem_OS

42.06 - Realizar a Criacao de Ordem OS
    [TAGS]                                  COMPLETO    42_06_Realizar_a_Criacao_de_Ordem_OS
    Inicia CT
    Retornar Token Vtal
    Criar Ordem Agendamento FTTP            VELOCIDADE=400
    Fecha CT  API  42_07_Realizar_Validacao_Criacao_da_Ordem_OS_no_FW_Console

42.07 - Realizar Validacao Criacao da Ordem (OS) no FW Console
    [TAGS]                                  COMPLETO    42_07_Realizar_Validacao_Criacao_da_Ordem_OS_no_FW_Console
    Inicia CT
    Validar Criação da Ordem
    Fecha CT  FW  42_08_Realizar_Validacao_no_SOM

42.08 - Realizar Validacao no SOM
    [TAGS]                                  COMPLETO    42_08_Realizar_Validacao_no_SOM
    Inicia CT
    Validacao da OS Completa FTTP  
    Fecha CT  COMPLETO  COMPLETO
