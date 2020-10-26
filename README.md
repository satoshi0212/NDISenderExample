# NDISenderExample

## Overview

Minimum implementation of the NDI SDK that works on the iPhone using Swift.

![output3](https://user-images.githubusercontent.com/5768361/97207673-9f32bf80-17fd-11eb-8cd6-9b5ed8791038.gif)

You'll need a high-speed network connection.

## How to use

1. Get the SDK from the [NDI SDK] (https://www.ndi.tv/sdk/) site and install it (using `4.5.3` as of 2020-10-27).

2. Copy `/Library/NDI SDK for Apple_/lib/iOS/libndi_ios.a` to `/NDISenderExample/NDIWrapper/NDIWrapper/wrapper/`

3. Open `NDISenderExample.xcworkspace` in Xcode, select the `NDISenderExample` schema, and run it.

4. tap the Send button on the screen to start sending with NDI.


## 概要

NDI SDKをSwiftから使用しiPhoneで動作させる最小実装です。

## 本リポジトリの使い方

1. [NDI SDK](https://www.ndi.tv/sdk/)サイト経由で取得するダウンロードリンクからSDKを入手しインストール(2020-10-27時点で `4.5.3` を使用)

2. `/Library/NDI SDK for Apple_/lib/iOS/libndi_ios.a` を `/NDISenderExample/NDIWrapper/NDIWrapper/wrapper/` にコピー

3. Xcodeで `NDISenderExample.xcworkspace` を開き `NDISenderExample` スキーマを選択し実行

4. 画面内のSendボタンをタップするとNDIで送信開始します。
