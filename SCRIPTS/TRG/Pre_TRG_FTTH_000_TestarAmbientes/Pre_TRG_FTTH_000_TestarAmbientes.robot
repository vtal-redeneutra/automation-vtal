*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
Resource                                    ../../RESOURCE/NETQ/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/Pre_TRG_FTTH_DAT_000_TestarAmbientes.xlsx


*** Test Cases ***
00.01 - Gerar token de acesso
    Retornar Token Vtal

00.02 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

00.03 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

00.04 - Realizar Consulta de Slots
    Consulta Slot Agendamento

00.05 - Realizar o Agendamento
    Realizar Agendamento

00.06 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento                 1000
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

00.07 - Validar a Criação da OS de Instalação via SOM
    @{LIST}=                                Create List                             ${SOM_Customer_Name}
    ...                                     ${SOM_Numero_Pedido}                    ${SOM_CEP}
    ...                                     ${SOM_Numero_SA}                        ${SOM_UF}

    @{RETORNO}=                             Create List                             Customer_Name
    ...                                     Associated_Document                     Address
    ...                                     Work_Order_Id                           UF

    Validar Evento Completo SOM             VALOR_PESQUISA=SOM_Order_Id
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                      ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

00.08 - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL

00.09 - Troca de técnico via FSL
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

00.10 - Realizar o Encerramento da OS de Instalação via FSL
    Validar Atribuicao Automatica FSL
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar o SA
    Validar Estado do pedido FSL
    Close Browser                           CURRENT

    Close Browser                           CURRENT

00.11 - Realizar Validação de Retorno via SOM
    Valida Evento SOM                       SOM_Order_Id                            Completed                               Oi Fibra Instalação

00.12 - Realizar configuração na ferramenta de mock 
    Alterar Campo no NETQ                   CAMPO=CONSULTA_SOM                      VALOR=ComOS                             RESET_JSON=SIM
    Alterar Campo no NETQ                   CAMPO=VULTOATIVO                        VALOR=INVENTORY_18                            

00.13 - Realizar Pré diagnostico após alteração no mock
    ${SUBSCRIBERID}                         Ler Variavel na Planilha                Subscriber_Id                           Global
    Escrever Variavel na Planilha           ${SUBSCRIBERID}                         subscriberId                            Global
    
    Realizar PreDiagnostico ou Diagnostico                                          preDiagnostic

00.14  - Validar retorno do pre-diagnostico no FW
    Escrever Variavel na Planilha           FINISHED                                state                                   Global
    Validar Evento FW                       VALOR_BUSCA=PreDiag_ID    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ServiceTestManagement.ListenerServiceTestResultEvent'])[1]        
    ...                                     XPATH_XML=(//*[text()="INVOKE - Request enviado para a ClienteCo"]/../..//textarea)[1]    
    ...                                     DADOS_XML=subscriberId,state
