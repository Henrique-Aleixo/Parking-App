# ULHT - App Estacionamentos (Disciplina de Computação Móvel)

## ScreenShots:
![Screenshot_1](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/e9f7ce79-1054-4c67-92c8-d5fad0244f2a)
![Screenshot_2](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/a7ce1ec1-c793-49d7-8b35-ab08045fe426)
![Screenshot_3](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/305e06e2-36c2-41f5-8e1e-29eb4eeccccf)
![Screenshot_4](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/fcd2960b-f52a-4c11-8cec-0f96c0fa70eb)
![Screenshot_5](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/22558975-def0-414f-8c8a-2e0f99ddb5c3)
![Screenshot_6](https://github.com/al3x-13/emel-parking-app-henrique/assets/95305819/548c41f8-4e45-4d0e-848a-22f274c36090)


## Funcionalidades:
| Descrição                        | Funcionalidade
|----------------------------------|----------------------------------
| Dashboard                        | Interface inicial com resumo das principais informações e acessos rápidos.
| Apresentação dos Parques - Lista | Exibição dos parques em formato de lista, com informações básicas de cada parque.
| Apresentação dos Parques - Mapa  | Visualização dos parques num mapa interativo, com possibilidade de navegação.
| Detalhe do Parque                | Tela detalhada com informações completas sobre cada parque selecionado.
| Registo de Incidentes            | Formulário para registo de incidentes nos parques, com armazenamento das informações numa base de dados.
| Navegação                        | Funcionalidade de navegação integrada para guiar o usuário até o parque escolhido.
| Arquitetura da Aplicação         | Estrutura modular e organizada da aplicação para facilitar a manutenção e escalabilidade.
| Geolocalização                   | Utilização dos serviços de geolocalização para localizar o usuário e mostrar parques próximos.
| Funcionamento Offline            | Suporte a operações básicas da aplicação sem necessidade de conexão com a internet.
| Apresentação dos parques GIRA - Mapa| Exibição dos parques GIRA num mapa interativo semelhante ao dos parques principais. (Através de um botão 'toggle')
| Detalhe GIRA                     |Tela detalhada com informações completas sobre cada parque GIRA selecionado.
| Formulário GIRA                  | Formulário específico para registo de incidentes relacionadas aos parques GIRA.

## Lógica de Negócio

1. Classe GiraIncident:
    - Atributos:
        * stationId - String
        * description - String
        * problemType - String
        * timestamp - DateTime
    - Métodos:
        * GiraIncident.fromDb(Map<String, dynamic> data)
        * Future<bool> saveToDb(Database db)

2. Classe GiraStation
    - Atributos:
        * id - String
        * numDocks - int
        * numBikes - int
        * address - String
        * coordinates - String
        * serviceLevel - String
        * state - String
        * lastUpdateTimestamp - String
    - Métodos:
        * GiraStation.fromDb(Map<String, dynamic> data)
        * Future<bool> saveToDb(Database db)
        * double getOccupationPercentage()
        * double? getDistanceInKm(AppData appData)
        * Future<List<GiraIncident>> getIncidents(Database db)

3. Classe LocationService:
    - Atributos:
        * serviceEnabled - bool
        * permission - LocationPermission

4. Class ParkIncident:
    - Atributos:
        * parkId - String
        * description - String
        * severity - int
        * timestamp - DateTime
        - Métodos:
        * ParkIncident.fromDb(Map<String, dynamic> data)
        * Future<bool> saveToDb(Database db)

5. Classe Park:
    - Atributos:
        * id - String
        * name - String
        * type - String
        * entityId - int
        * lat - String
        * lon - String
        * maxCapacity - int
        * ocupation - int
        * occupationTimestamp - String
        * active - bool
    - Métodos:
        * Park.fromMap(Map<String, dynamic> data)
        * Park.fromDb(Map<String, dynamic> data)
        * Future<bool> saveToDb(Database db)
        * int getIdAsInt()
        * double? getDistanceInKm(AppData appData)
        * double getOccupationPercentage()
        * Future<List<ParkIncident>> getIncidents(Database db) 

## Arquitetura da aplicação
A arquitetura da aplicação foi desenvolvida com um foco em boas práticas de arquitetura e design, visando uma solução robusta, escalável e de fácil manutenção. 

- Componentização
A aplicação é dividida em módulos distintos, onde cada funcionalidade principal é encapsulada em componentes reutilizáveis. Por exemplo, temos componentes específicos para a lista de parques, mapa de parques, detalhe de parques, registro de incidentes. Essa abordagem permite uma melhor organização do código e facilita a reutilização de componentes em diferentes partes da aplicação.

- Navegação com Bottom Bar
A navegação principal da aplicação é realizada através de uma bottom bar, que oferece acesso rápido e intuitivo às principais seções da aplicação, como Dashboard, Lista de Parques, Mapa de Parques, e mais. Essa escolha de navegação melhora a usabilidade, permitindo que os usuários alternem facilmente entre diferentes ecrãs.

- Model-View-Controller
Utilizei Model-View-Controller para separar a lógica de apresentação dos dados, promovendo uma interface de usuário reativa e de fácil manutenção.Também facilitando a troca de fontes de dados (como APIs ou banco de dados local) sem impactar outras partes da aplicação.

- Geolocalização
A aplicação utiliza serviços de geolocalização para identificar a localização do usuário e apresentar parques próximos, melhorando a relevância das informações mostradas.

- Funcionamento Offline
Para melhorar a experiência do usuário, a aplicação suporta funcionalidades básicas mesmo sem conexão com a internet. É utilizado armazenamento local para guardar dados essenciais e sincronizá-los quando a conexão for restabelecida.

- UI/UX Clean e Funcional
Adotei princípios de design clean e funcional, garantindo que a interface do usuário seja intuitiva e fácil de usar. A paleta de cores, tipografia e layout são consistentes em toda a aplicação, proporcionando uma experiência de usuário agradável e coerente.

## Video Apresentação
- [Link Youtube](https://youtu.be/Q6RF7s3jduU)

## Previsão da Nota
- 14 (Projeto de Recurso)

## Fontes de Informação
- [Google Maps API](https://developers.google.com/maps?hl=pt-br)
- [Geolocator](https://pub.dev/packages/geolocator)
- [Flutter Documentation](https://docs.flutter.dev/)

## Autores
- [@Henrique Aleixo-a22103544](https://github.com/Henrique-Aleixo)

