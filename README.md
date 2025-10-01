# 💱 Currency Converter App

A simple **Flutter application** that converts currencies using the
[FXRates API](https://fxratesapi.com).\
The app provides a clean interface to input an amount, select base and
target currencies, and instantly see the converted result.

------------------------------------------------------------------------

## ✨ Features

-   🔄 Real-time currency conversion using **FXRates API**\
-   🎨 Beautiful UI with styled dropdowns and input fields\
-   📱 Responsive and modern Flutter design\
-   🌍 Supports multiple currencies (USD, EUR, INR, JPY, GBP, and more)

------------------------------------------------------------------------

## 📸 Screenshots

(Add your app screenshots here once you run it)

------------------------------------------------------------------------

## 🛠️ Technologies Used

-   [Flutter](https://flutter.dev)\
-   [Dart](https://dart.dev)\
-   [http](https://pub.dev/packages/http) for API calls\
-   [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) for
    environment variables

------------------------------------------------------------------------

## ⚙️ Setup & Installation

### 1. Clone the Repository

``` bash
git clone https://github.com/<your-username>/currency-converter.git
cd currency-converter
```

### 2. Install Dependencies

``` bash
flutter pub get
```

### 3. Add Environment Variables

Create a `.env` file in the project root and add your **FXRates API
key**:

    FXRATES_API_KEY=your_api_key_here

### 4. Run the App

``` bash
flutter run
```

------------------------------------------------------------------------

## 📂 Project Structure

    lib/
     ├── currency_converter_material_app.dart   # Main UI + logic
     ├── constants/
     │    └── available_currencies.dart         # List of currencies

------------------------------------------------------------------------

## 🚀 How It Works

1.  Select the **base currency** and **target currency** from
    dropdowns.\
2.  Enter the amount you want to convert.\
3.  Tap **Convert** → The app fetches the real-time conversion rate via
    API and displays the result.

------------------------------------------------------------------------


