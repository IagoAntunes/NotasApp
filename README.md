# Notas App

Este projeto é uma aplicação de gerenciamento de notas desenvolvida utilizando o framework **Flutter**. O objetivo é fornecer uma interface multiplataforma (Android e iOS) para criação e armazenamento de anotações, integrando serviços de backend e boas práticas de desenvolvimento.

## 📑 Índice

* [📍 Vídeo](#-vídeo)
* [✨ Funcionalidades](#-funcionalidades)
* [✅ Como Validar o Projeto](#-como-validar-o-projeto)
* [🛠 Tecnologias e Ferramentas](#-tecnologias-e-ferramentas)
* [📂 Arquitetura e Estrutura de Pastas](#-arquitetura-e-estrutura-de-pastas)
* [🚀 Como Executar o Projeto](#-como-executar-o-projeto)


## 📍 Vídeo

https://github.com/user-attachments/assets/3c436474-e9fd-46b1-a9e1-4cd67059f186

## ✨ Funcionalidades

* **📱 Identidade Visual Personalizada:**
    * **Ícone Adaptativo:** Ícone do aplicativo configurado para diferentes densidades e formatos de dispositivos Android e iOS.
    * **Native Splash Screen:** Tela de abertura nativa configurada para uma experiência de inicialização fluida.

* **🔐 Autenticação Robusta:**
    * Login e Registro de usuários integrados ao **Firebase Auth**.
    * **Validação de Formulários:** Feedback visual imediato para emails inválidos ou senhas fracas.
    * Tratamento de erros amigável para o usuário.

* **☁️ Gerenciamento de Notas (Offline-First):**
    * **CRUD Completo:** Criação, leitura, atualização e exclusão de notas.
    * **Sincronização Inteligente:** O app funciona perfeitamente sem internet. As alterações são salvas localmente (cache) e sincronizadas automaticamente com o Firestore assim que a conexão é restabelecida.
    * **Otimistic UI:** A interface responde instantaneamente às ações do usuário, independente da latência da rede.

* **📊 Análise e Estatísticas:**
    * Visualização detalhada do conteúdo da nota através de gráficos.
    * Contagem precisa de **caracteres**, **letras**, **números** e **linhas visuais** (simulação de renderização para contagem exata de quebras de linha na tela).

## ✅ Como Validar o Projeto

Para testar o funcionamento da aplicação, você possui duas opções:

````
email: admin@gmail.com
password: admin123
````
### Opção 1: Instalação via APK (Rápido)
A maneira mais simples de visualizar o projeto rodando em um dispositivo Android, sem necessidade de configurar o ambiente de desenvolvimento:

1. Acesse a aba **Releases** deste repositório.
2. Localize a versão mais recente (tag `Latest`).
3. Baixe o arquivo `app-release.apk` nos "Assets".
4. Instale o arquivo em seu dispositivo Android.

### Opção 2: Compilação via Código Fonte
Caso queira analisar o código, debugar ou rodar em um simulador iOS:

1. Siga as instruções detalhadas na seção **"🚀 Como Executar o Projeto"** abaixo.

## 🛠 Tecnologias e Ferramentas

O projeto foi construído utilizando as seguintes tecnologias:

* **Linguagem:** [Dart](https://dart.dev/)
* **Framework:** [Flutter](https://flutter.dev/)
* **Backend/Infraestrutura:** [Firebase](https://firebase.google.com/)
* **Gerenciamento de Estado:** [MobX](https://pub.dev/packages/mobx)
* **Navegação:** [GoRouter](https://pub.dev/packages/go_router)
* **Injeção de Dependência:** [GetIt](https://pub.dev/packages/get_it)
* **Armazenamento:** [SharedPreferences](https://pub.dev/packages/shared_preferences)
* **Mock:** [Mocktail](https://pub.dev/packages/mocktail)

## 📂 Arquitetura e Estrutura de Pastas

````
lib/
├── core/                         # Configurações centrais e utilitários
│   ├── di/                       # Injeção de dependência
│   ├── router/                   # Configuração de rotas e navegação
│   ├── styles/                   # Estilos, temas e cores globais
│   ├── utils/                    # Funções utilitárias e helpers
│   └── widgets/                  # Widgets core/básicos da aplicação
│
├── services/                     # Serviços de terceiros e infraestrutura
│   ├── database/                 # Configuração de banco de dados
│   └── stateManager/             # Gerenciamento de estado MOBX
│
├── shared/                       # Módulos ou entidades compartilhadas
│   └── note/                     # Recurso de "Notas" compartilhado
│       ├── domain/
│       ├── external/
│       └── infra/
│
└── src/                          # Funcionalidades principais (Features)
    ├── auth/                     # Módulo de Autenticação
    │   ├── domain/               # Regras de negócio
    │   │   ├── models/           # Entidades
    │   │   └── repository/       # Contratos/Interfaces dos repositórios
    │   ├── external/             # Fontes de dados externas
    │   │   └── datasource/       # Implementação das datasources
    │   ├── infra/                # Camada de adaptação
    │   │   ├── datasource/       # Contratos das datasources
    │   │   └── repository/       # Implementação dos repositórios
    │   └── presentation/         # Camada de visualização
    │       ├── container/        # Injeção de dependências da tela
    │       ├── controller/       # Lógica de controle da tela
    │       ├── screens/          # As telas (UI)
    │       └── states/           # Estados da tela
    │
    └── home/                     # Módulo Home
        ├── domain/
        │   └── models/
        └── presentation/
            ├── container/
            ├── controller/
            ├── screens/
            └── states/
````

## 🚀 Como Executar o Projeto

### Pré-requisitos

Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado em sua máquina.

### Passos para Instalação

1. **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    cd notes_app
    ```

2. **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3. **Configuração do Firebase:**
    Caso as configurações atuais não funcionem, é preciso adicionar seus proprios arquivos `google-services.json` (Android) e `GoogleService-Info.plist` (iOS).

5. **Execute a aplicação:**
    ```bash
    flutter run
    ```
