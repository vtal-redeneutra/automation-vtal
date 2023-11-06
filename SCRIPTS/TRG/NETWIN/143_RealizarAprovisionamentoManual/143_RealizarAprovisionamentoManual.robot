*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/143_RealizarAprovisionamentoManual.xlsx


*** Test Cases ***
143.01 - Validar Disponibilidade de Endereço
    Consultar Viabilidade Netwin

143.02 - Criar Ordem IP Connect
    Cria Ordem IP Connect

143.03 - Gerar Arquivo para envio ao NA com CPE
    Gerar Arquivo ao NA                     COM_CPE=SIM

143.04 - Validar Ordem de Venda ou Modificação
    Validar Conclusão de Ordem              TIPO_ORDEM=ACESSO GPON
    ...                                     ESTADO_ITEM=Activo

143.05 - Validar Disponibilidade de Endereço
    Consultar Viabilidade Netwin            MASSA=2

143.06 - Criar Ordem IP Connect - Massa 2
    Cria Ordem IP Connect                   MASSA=2

143.07 - Geração de arquivos para envio ao NA sem CPE
    Gerar Arquivo ao NA                     COM_CPE=NAO
    ...                                     MASSA=2

143.08 - Validar Ordem de Venda ou Modificação
    Validar Conclusão de Ordem              TIPO_ORDEM=ACESSO GPON
    ...                                     ESTADO_ITEM=Activo
    ...                                     MASSA=2