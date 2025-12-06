# Notas App

Este projeto é uma aplicação de gerenciamento de notas desenvolvida utilizando o framework **Flutter**. O objetivo é fornecer uma interface multiplataforma (Android e iOS) para criação e armazenamento de anotações, integrando serviços de backend e boas práticas de desenvolvimento.

## 🛠 Tecnologias e Ferramentas

O projeto foi construído utilizando as seguintes tecnologias baseadas na estrutura do repositório:

*   **Linguagem:** [Dart](https://dart.dev/)
*   **Framework:** [Flutter](https://flutter.dev/)
*   **Backend/Infraestrutura:** [Firebase](https://firebase.google.com/) (identificado pelo arquivo `firebase.json`).
*   **Análise Estática:** Configurada via `analysis_options.yaml` para garantir a qualidade e padronização do código Dart.
*   **DevTools:** Configurações personalizadas presentes em `devtools_options.yaml`.
*   **Gerenciamento de Dependências:** Pub (via `pubspec.yaml`).

## 📂 Arquitetura e Estrutura de Pastas

A estrutura do projeto segue os padrões do Flutter, organizada da seguinte forma:

*   **`lib/`**: Contém o código-fonte principal da aplicação (Dart). É aqui que residem as camadas de UI, lógica de negócios e integração de dados.
*   **`test/`**: Contém os testes automatizados (Unitários e de Widget) para garantir a estabilidade das funcionalidades.
*   **`assets/`**: Diretório dedicado a recursos estáticos como imagens, fontes e arquivos de configuração locais.
*   **`android/` & `ios/`**: Pastas contendo o código nativo e configurações específicas para cada plataforma móvel.
*   **`firebase.json`**: Arquivo de configuração para integração e deploy de serviços do Firebase.
*   **`analysis_options.yaml`**: Regras de linter para manter o estilo do código consistente.

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
