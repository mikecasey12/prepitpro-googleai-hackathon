# PrepItPro

PrepItPro is an education app designed to help students prepare for exams efficiently. The app offers various features such as practicing past questions, generating questions from notes, and exploring subjects of interest.

## Features

- **Practice Past Questions:** Access a database of past exam questions to practice and reinforce learning.
- **Generate Questions from Notes:** Utilize your own notes to generate custom questions tailored to your study materials.
- **Explore Subjects:** Discover new subjects and topics based on your interests to broaden your knowledge base.

## Technologies Used

- **Flutter:** The app is built using the Flutter framework, allowing for seamless cross-platform compatibility.
- **Supabase:** Utilized for backend services including authentication, authorization, storage, and edge functions, ensuring secure and efficient data management.
- **Firebase:** Integrated for push notifications and in-app messaging, enhancing user engagement and communication.

## Installation

To install and run PrepItPro locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/mikecasey12/prepitpro-googleai-hackathon.git
   ```

2. Navigate to the project directory:

   ```bash
   cd prepitpro
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Initialize Firebase:

   ```bash
   flutterfire configure
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Extras

The app makes use of the Envied dart package. Read more on setup and usage [here](https://pub.dev/packages/envied).

Also for details on how to setup and use supabase. Read the [documentation](https://supabase.com/docs/guides/getting-started/quickstarts/flutter) on how to setup supabase on flutter.

## What don't work

Only SS3 students currently have subjects, so to test the app, make sure your registration class is that of SS3.
Notifications settings don't work yet.
External exams don't show the correctly.
Share link not with correct link.
