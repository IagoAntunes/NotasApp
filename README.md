# Notas App

Este projeto é uma aplicação de gerenciamento de notas desenvolvida utilizando o framework **Flutter**. O objetivo é fornecer uma interface multiplataforma (Android e iOS) para criação e armazenamento de anotações, integrando serviços de backend e boas práticas de desenvolvimento.

## ✅ Como Validar o Projeto

Para testar o funcionamento da aplicação, você possui duas opções:

### Opção 1: Instalação via APK (Rápido)
A maneira mais simples de visualizar o projeto rodando em um dispositivo Android, sem necessidade de configurar o ambiente de desenvolvimento:

1.  Acesse a aba **[Releases](../../releases)** deste repositório (na barra lateral direita do GitHub).
2.  Localize a versão mais recente (tag `Latest`).
3.  Baixe o arquivo `app-release.apk` nos "Assets".
4.  Instale o arquivo em seu dispositivo Android.

### Opção 2: Compilação via Código Fonte
Caso queira analisar o código, debugar ou rodar em um simulador iOS:

1.  Siga as instruções detalhadas na seção **"🚀 Como Executar o Projeto"** abaixo.

## 🛠 Tecnologias e Ferramentas

O projeto foi construído utilizando as seguintes tecnologias baseadas na estrutura do repositório:

*   **Linguagem:** [Dart](https://dart.dev/)
*   **Framework:** [Flutter](https://flutter.dev/)
*   **Backend/Infraestrutura:** [Firebase](https://firebase.google.com/) (identificado pelo arquivo `firebase.json`).

*   **Gerenciamento de Estado:** [Mobx](https://pub.dev/packages/mobx)
*   **Navegação:** [GoRouter](https://pub.dev/packages/go_router)
*   **Armazenamento:** [SharedPreferences](https://pub.dev/packages/shared_preferences)


## 📂 Arquitetura e Estrutura de Pastas

A estrutura do projeto segue os padrões do Flutter, organizada da seguinte forma:

*   **`lib/`**: Contém o código-fonte principal da aplicação (Dart). É aqui que residem as camadas de UI, lógica de negócios e integração de dados.
*   **`test/`**: Contém os testes automatizados (Unitários e de Widget) para garantir a estabilidade das funcionalidades.
*   **`assets/`**: Diretório dedicado a recursos estáticos como imagens, fontes e arquivos de configuração locais.
*   **`android/` & `ios/`**: Pastas contendo o código nativo e configurações específicas para cada plataforma móvel.

*   **`controller/`**: Esta é a camada que conversa diretamente com a Interface (Tela). Dependendo da arquitetura, pode ser chamada de ViewModel, Bloc, ou Store.
*   **`repository/`**: Esta é a camada de decisão e proteção. Ela serve como um "escudo" para o resto do aplicativo e é onde reside o contrato de dados.
*   **`datasource/`**: Esta é a camada mais "externa" e técnica. Ela não sabe nada sobre regras de negócio; ela apenas sabe como buscar dados.


## 🚀 Como Executar o Projeto

### Pré-requisitos

Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado em sua máquina.

### Passos para Instalação

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    cd notes_app
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Configuração do Firebase:**
    Como o projeto utiliza Firebase, certifique-se de que suas credenciais e arquivos de configuração (como `google-services.json` para Android e `GoogleService-Info.plist` para iOS) estejam configurados corretamente nas pastas nativas, caso não estejam versionados.

4.  **Execute a aplicação:**
    ```bash
    flutter run
    ```
