# 🔐 Auth Firebase

Aplicativo Android desenvolvido em **Flutter** para cadastro, login e recuperação de senha usando **Firebase Authentication**.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white" alt="Flutter 3.47">
  <img src="https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white" alt="Dart 3.13">
  <img src="https://img.shields.io/badge/Firebase-Authentication-FFCA28?logo=firebase&logoColor=black" alt="Firebase Authentication">
</p>

## ✨ Funcionalidades

- Cadastro com e-mail e senha.
- Login com e-mail e senha.
- Envio de link para redefinir a senha.
- Redirecionamento entre login e início conforme o estado de autenticação do Firebase.
- Interface escura com animação Lottie.

## 🧰 Tecnologias

- Flutter e Dart
- Firebase Core
- Firebase Authentication
- Lottie

## 🚀 Como executar

### Pré-requisitos

- Flutter 3.47 ou superior e Dart 3.13 ou superior.
- Android SDK e um dispositivo ou emulador Android.
- Um projeto Firebase com o provedor **E-mail/senha** ativado em **Authentication → Sign-in method**.

### Instalação

```powershell
git clone https://github.com/patr0ka/apk_authentication_firebase.git
cd apk_authentication_firebase
Copy-Item .env.example .env
# Preencha os valores do Firebase no arquivo .env antes de continuar.
flutter pub get
flutter run
```

Para gerar o APK de release:

```bash
flutter build apk --release
```

O APK será gerado em `build/app/outputs/flutter-apk/app-release.apk`.

## 🔥 Configuração do Firebase

O app carrega a configuração cliente Firebase do arquivo local `.env`, que não é versionado. O arquivo `.env.example` lista os campos necessários. Crie sua cópia e preencha-a com os valores do app Android no Firebase Console.

O pacote Android é `com.example.auth_ta`. O Gradle gera localmente o `google-services.json` a partir do `.env` durante o build; esse arquivo gerado é ignorado pelo Git.

Para usar outro projeto Firebase:

1. Registre um app Android com o pacote `com.example.auth_ta` no Firebase Console.
2. Ative **Authentication → Sign-in method → E-mail/senha**.
3. Copie os dados de configuração do app Android para o `.env` local.

### Nota sobre a chave de API

As chaves usadas pela configuração cliente do Firebase identificam o projeto e podem ser extraídas do APK. O `.env` evita versionar esses valores no repositório, mas não os torna segredos dentro do aplicativo. Restrinja a chave às APIs Firebase necessárias e acompanhe as cotas de autenticação, especialmente para `identitytoolkit.googleapis.com`. **Nunca** publique chaves de conta de serviço ou outras credenciais privadas. Consulte a [documentação de segurança das chaves de API do Firebase](https://firebase.google.com/docs/projects/api-keys).

## 📌 Estado do projeto

O cadastro, o login e a solicitação de redefinição de senha usam Firebase Authentication. Os botões de Google e Apple e os itens de navegação da tela inicial são elementos visuais; esses fluxos ainda não estão implementados.
