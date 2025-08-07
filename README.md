# 🤖 Chatbot Flutter avec LM Studio (Projet de stage)

Ce projet est une application mobile Flutter intégrée avec **LM Studio** et **Mistral 7B** pour créer un **chatbot local**, sans passer par une API en ligne. Ce projet a été réalisé dans le cadre d’un stage.

---

## 📱 Fonctionnalités

- Interface de **connexion** (login)
- Enregistrement des utilisateurs dans un **fichier local**
- Communication avec un **LLM local (Mistral 7B)** via **LM Studio**
- Animation de texte "le bot écrit"
- Historique des conversations
- UI design moderne (Material 3)

---

## 🚀 Démarrage rapide

### 1. Prérequis

- Flutter installé : [flutter.dev/docs/get-started](https://flutter.dev/docs/get-started)
- LM Studio installé : [lmstudio.ai](https://lmstudio.ai)
- Modèle téléchargé : `mistral-7b-instruct-v0.2.Q4_K_M.gguf`

### 2. Lancer LM Studio

- Ouvre LM Studio
- Charge le modèle `mistral-7b-instruct-v0.2.Q4_K_M.gguf`
- Clique sur l’onglet **"OpenAI Compatible API"**
- Active l’API sur le port `1234`

### 3. Lancer le projet Flutter

```bash
flutter pub get
flutter run

###🔐 Fichier utilisateur local
Les utilisateurs sont enregistrés localement dans un fichier texte ou JSON (selon ta version). Cela permet de tester l’authentification sans base de données externe.

🛠️ Technologies utilisées
Flutter

Dart

LM Studio (serveur d’API local)

Mistral 7B Instruct

Material Design 3

👩‍💻 Auteure
Nour Chamakh
Projet réalisé dans le cadre d’un stage pratique de développement mobile.

