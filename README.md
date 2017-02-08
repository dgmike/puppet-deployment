Puppet Deployment
=================

Este é um projeto para fins de estudo de docker-compose e puppet e não é
recomendado utilizá-lo num ambiente de produção de verdade. Ao invés disso,
experimente criar suas soluções ou usar alguns módulos criados pela comunidade.

O projeto consiste em uma série de máquinas a partir de dockers que simulam
um ambiente produtivo. O uso do Docker se deve ao fato de ele conseguir simular
o ambiente de máquinas de uma empresa sem precisar de fato se preocupar por
questões de firewall ou acesso as máquinas. Para realizar esta operação o Docker
se valhe do plugin chamado docker-compose, que levanta as máquinas e compartilha
a rede interna entre elas.

Docker consegue criar máquinas com uma série de recursos como máquinas já com
banco de dados ou servidores instalados. Apesar desse fato, o projeto tenta
manter as imagens do docker o mais puro possível. São máquinas CentOs com o
puppet instalado.

Requisitos
----------

Para testar o sistema você vai precisar:

- docker
- docker-compose

Por que Puppet e não Chef?
--------------------------

Acredito que puppet tenha uma proposta mais interessante no que diz respeito
a facilidade de uso e a linguagem é mais legível e aceitável do que linguagem
ruby, que é como o Chef trabalha.

Em contra partida, o Chef possui muitos recursos que facilitaria o dia-a-dia do
profissional de DevOps. Mas não é o caso deste projeto, que é muito menos
complexo.

Estrutura
---------

O eco sistema está dividido em duas partes: puppet master e puppet clients.
Onde, o puppet master é responsável por manter as receitas que serão instaladas
nas máquinas. Já os clients são máquinas que executão as receitas, a fim de se
assemelharem ao padrão requisitado para o eco sistema funcionar.

As máquinas cliente são separadas em dois tipos: aplicações e balancer. Nas
máquinas de aplicações são instalados o pacote nginx e o servidor é servido
na porta 80. O balancer é comportado com uma aplicação haproxy e é configurada
de forma a diminuir o tráfego do site.

Configurando
------------

A configuração das máquinas encontra-se no `docker-compose.yml`. Para cada
máquina, o sistema expõe algumas pastas a fim de configurar o ambiente
(produção, homologação, etc). Para tanto existe, na raiz do projeto encontra-se
uma pasta chamada `machinne_template` que pode ser utilizada como base para
criar uma nova máquina.

A configuração da disposição das máquinas encontra-se no arquivo de configuração
de variáveis do puppet server em:

    ./hieradata/defaults.yaml
    ./hieradata/%{environment}.yaml

A configuração é feita através de grupos de máquinas, onde cada grupo possui
uma versão da aplicação (apenas muda o arquivo de configuração) e expô-las
em portas diferentes, o que possibilita o deploy utilizando a prática de
_green/blue_.

Essa tática implica em realizar a instalação da versão mais nova nas máquinas
e depois de testar, fazer a troca da porta que expõe o projeto, fazendo com
que o deploy seja instantâneo não não exiba erros ao usuário final.

Veja, como é simples fazer a troca:

```yaml
deploy_strategy:
  groups:
    blue:
      app_version: v0.0.2
      frontend_port: 5001
      clients:
        - production_blue1
        - production_blue2
    green:
      app_version: v0.0.3
      frontend_port: 5002
      clients:
        - production_green1
        - production_green2
```

No exemplo acima, podemos considerar o grupo de máquinas que está sendo
servido na porta `5001` como o ambiente produtivo, que tem o projeto
instalado na versão `v0.0.2`. Já o projeto que está sendo servido na
porta `5002` está com a versão `v0.0.3` e sendo testado pela equipe.

Após verificar que o ambiente está seguro para ir para produção, basta
configurar o arquivo da seguinte maneira:

```yaml
deploy_strategy:
  groups:
    green:
      app_version: v0.0.3
      frontend_port: 5001
      clients:
        - production_green1
        - production_green2
    blue:
      app_version: v0.0.2
      frontend_port: 5002
      clients:
        - production_blue1
        - production_blue2
```

E, logo após isso, pedir para o puppet realizar as devidas alterações.
O que fará com que o grupo `green` seja servido na porta `5001`,
que é o ambiente de produção.

Levantando e parando as máquinas
--------------------------------

Para levantar as máquinas basta executar o comando do `docker-compose`.

```bash
docker-compose up -d
```

Isto levantará todas as máquinas cadastradas em `docker-compose.yml`.

Para parar as máquinas, o `docker-compose` pode dar uma ajuda também.

```bash
docker-compose down
```

Puppet
------

Aperar de o puppet ser executado periodicalmente através do agente. É
mais interessante ver a alteração necessária o mais breve possível.

Então, com as máquinas levantadas, você pode acessar a máquina através
do comando `run`.

```bash
docker-compose exec [NOME_DA_MAQUINA] bash
```

Ele acessará a máquina como num acesso via `ssh`. E, uma vez dentro da
máquina, basta pedir ao puppet para realizar as alterações:

```bash
puppet agent -t
```

Este procedimento deve ser executado em todas as máquinas do tipo
cliente para uma maior consistência.

Makefile
--------

Para facilitar os processos, um arquivo `Makefile` foi desenvolvido a
fim de diminuir a quantidade de linhas de comando necessárias para
realizar as operações do dia-a-dia.

Para levantar todas as máquinas por exemplo, basta executar:

```bash
make up
```

| Comando        | Descrição                                              |
|----------------+--------------------------------------------------------|
| make up        | Levanta as máquinas                                    |
| make down      | Para os serviços                                       |
| make update    | Executa a atualização do puppet em todas as máquinas   |
| make cert-list | Lista as máquinas registradas no puppet master         |
| make clean     | Apaga as máquinas que foram utilizadas pelo Docker     |
| make build     | Levantas as máquinas e executa a atualização do puppet |
| make rebuild   | Para as máquinas e executa o build                     |
| make create_machinne | Cria uma máquina com base no template            |

