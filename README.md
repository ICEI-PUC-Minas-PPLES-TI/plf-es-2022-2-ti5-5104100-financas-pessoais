# WeBudget

De acordo com pesquisas realizadas pelo SPC Brasil e pela Confederação Nacional de Dirigentes Lojistas (CNDL), "seis em cada 10 brasileiros (58%) admitem nunca, ou somente as vezes, dedicam a atividades de controle da vida financeira." (SOUZA, 2018)  

Esse controle financeiro é essencial para ter uma qualidade de vida. E com o mundo cada vez mais tecnológico, o smartphone se torna um elemento imprescindível nessa busca.

Diante desta perspectiva, foi proposto o desenvolvimento de uma solução para o auxílio no controle, organização e planejamento financeiro pessoal. O usuário poderá controlar as despesas por categoria, receitas, criar metas financeiras e visualizar todas as informações por meio de gráficos.  

Os objetivos específicos do projeto são:

- Auxiliar o usuário no controle de metas de despesas, receitas e investimentos;
- Possibilitar o usuário a gestão de objetivos financeiros de curto, médio e longo prazo;
- Possibilitar o usuário salvar o local das compras realizadas com a utilização do GPS.

O sistema terá uma versão mobile e uma versão web.

## Integrantes

* [Helen Camila de Oliveira Andrade](https://github.com/HelenAndrade10)
* [Izabella de Castro Lucas](https://github.com/Izabella-Castro)
* [Nataniel Geraldo Mendes Peixoto](https://github.com/Nataniel93)
* [Pedro Campos Miranda](https://github.com/campos2504)
* [Pedro Henrique Gonçalves Barcelos](https://github.com/pedrobarcelos)

## Orientadores

* Cleiton Silva Tavares
* José Laerte Pires Xavier Junior

## Instruções de utilização

Seguindo o passo a passo, será possível estar realizando uma cópia do projeto rodando em sua máquina local com o próprosito de estar testando e desenvolvendo.

### Passo a passo de: como iniciar a aplicação

Pré-requisito:
- Ter instalado [Flutter na versão 2.18.5](https://docs.flutter.dev/development/tools/sdk/releases)
- Ter instalado [VsCode](https://code.visualstudio.com/download)
- Ter instalado [Visual Studio](https://visualstudio.microsoft.com/pt-br/downloads/)
- Ter instalado [SQL Server Management Studio](https://learn.microsoft.com/pt-br/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16)

<br>

### Passo 1: Clonar o repositório
```bash
$ git clone https://github.com/ICEI-PUC-Minas-PPLES-TI/plf-es-2022-2-ti5-5104100-financas-pessoais.git
```
<br>

### Passo 2: Configurar o backend

- Entrar na pasta do backend:
```bash
$ cd plf-es-2022-2-ti5-5104100-financas-pessoais\codigo\backend\WeBudgetWebApplication
```

- Criar um banco local no SSMS  

  Seguir o passo a passo [criando um banco de dados local](https://learn.microsoft.com/pt-br/sql/ssms/download-sql-server-management-studio-ssms)

- alterar a configuração no appsettings do backend

  Altere a string de conexão do banco de dados da Azure para o seu banco criado 

- Carregar as tabelas para o seu banco local

  Na liha de comando do Visual Studio inserida: 
  ```bash
  database update
   ```

<br>

### Passo 3: Configurar o frontEnd

- Entrar na pasta do frontend:

```bash
$ cd plf-es-2022-2-ti5-5104100-financas-pessoais\codigo\web\WeBudget\HTML
```

- Comando de abertura do código:

```bash
$ code .
```
<br>

### Passo 4: Configurar o Flutter (Frontend mobile)


- Entrar na pasta do frontend mobile:

```bash
$ cd plf-es-2022-2-ti5-5104100-financas-pessoais\codigo\mobile\we_budget
```

- Instalar as dependências do projeto Flutter:

```bash
$ flutter pub get
```

- Iniciar o Flutter no navegaodr Chrome:

```bash
$ flutter run -d chrome
```
- Iniciar o Flutter no emulador:

    No visualCode você deverá se conectar em um dispositivo e logo em seguida estar executando sem depuração o programa. 
    Para o AndroidSudio será necessário a criação de um emulador para estar executando


## Referências

SOUZA, Ludmilla. Pesquisa revela que 58% dos brasileiros não se dedicam às próprias finanças. 2018. Agência Brasil. Disponível em: https://agenciabrasil.ebc.com.br/economia/noticia/2018-03/pesquisa-revela-que-58-dos-brasileiros-nao-se-dedicam-proprias-financas
