*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference
...                                         OUPUT: Appointment_Start, Work_Order_Id, SOM_Order_Id, MaxBandWidth, Associated_Document, Correlation_Order, Associated_Document_Date, Name, Catalog_Id, Availability_Description, Inventory_Id, Type_Logradouro, Address_Name, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3 
    

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot   
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              C:/IBM_VTAL/DATA/TRG_FTTP_DAT_042_AtivacaoSemComplemento.xlsx


*** Test Cases ***

42.01 - Gerar Token de Acesso 
    Retornar Token Vtal

42.02 e 03 - Realizar consulta de Logradouro
    Consulta Id Logradouro

42.04 e 05 - Realizar consulta de Complemento e Realizar consulta de viabilidade
    Retorna Viabilidade dos Produtos

42.06 - Realizar a Criação de Ordem OS
    Criar Ordem Agendamento FTTP            VELOCIDADE=400

42.07 - Realizar Validação Criação da Ordem (OS) no FW Console
    Validar Criação da Ordem

42.08 - Realizar Validação no SOM
    Validacao da OS Completa FTTP  
    