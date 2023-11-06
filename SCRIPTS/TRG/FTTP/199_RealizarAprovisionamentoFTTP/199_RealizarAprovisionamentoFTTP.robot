*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0049_ValidarOrdemVendaOuModificacaoNetwin/ROB0049_ValidarOrdemVendaOuModificacaoNetwin.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/199_RealizarAprovisionamentoFTTP.xlsx

*** Test Cases ***
199.01 - Gerar Token de Acesso
    Retornar Token Vtal

199.02 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

199.03 - Realizar Consulta de Complemento
    Consultar Complements

199.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

199.05 - Realizar a Criação de Ordem (OS)
    Criar Ordem Agendamento FTTP            VELOCIDADE=400

199.06 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar Criação da Ordem

199.07 - Validar a Conclusão da OS de Instalação via SOM
    Validacao da OS Completa FTTP

199.08 - Validar de Notificação de Encerramento via FW 
        Validar Evento FW                   VALOR_BUSCA=associatedDocument    
        ...                                 XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
        ...                                 RETORNO_ESPERADO=>204<


199.09 - Validar Ordem de Venda ou Modificação
    Validar Ordem Venda ou Modificacao