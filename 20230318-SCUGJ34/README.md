# Demo for SCUGJ#34

## Demo 1

このデモでは、Windows Server 2022 Azure Edition 上に Azure Automanage Machine Configuration のオーサリング環境を作成し、以下を行います。

- サンプル DSC リソースの作成
- サンプル DSC リソースを使用した Windows 向けの構成 (Configuration) の作成
- 構成パッケージの作成
- Windows 環境を使用した構成パッケージのテスト
- 構成パッケージの配置 (Azure Blob Storage への配置・公開)
- 構成パッケージの適用
- 構成パッケージの Azure Arc 対応サーバー (Windows) への適用

## Demo 2

このデモでは、Ubuntu 18.04 LTS を使用し、Linux 環境向けに作成した構成パッケージのテストを行います。

### Demo 2-1

Demo 1 で準備した環境 (Windows Server 2022 Azure Edition) を使用し、Linux 環境向けの構成パッケージを作成します。

- サンプル DSC リソースを使用した Linux 向けの構成 (Configuration) の作成
- 構成パッケージの作成

### Demo 2-2

Demo 2-1 で作成した構成パッケージを Ubuntu 18.04 LTS 上でテストし、その後展開します。

- Windows 環境を使用した構成パッケージのテスト
- 構成パッケージの Azure Arc 対応サーバー (Linux) への適用

## デモ用のサンプル DSC リソース

Scugj34SampleDscResource は指定されたパスに指定されたコンテンツのファイルが配置されているかどうかをチェック・設定するリソースです。

- path : ファイルのパス
- content : ファイルの内容(テキスト)

Last update : 2023-03-19
