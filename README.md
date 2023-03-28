# Terraformで作成する構成
<img width="600" alt="ECSApp.drawio.png" src="ECSApp.drawio.png">

※構成図は暫定です。

[istone-you/memo-app-mern-stack](https://github.com/istone-you/memo-app-mern-stack)にて作成したアプリをAWSのECSでCodePipelineを使って構築するTerraformファイルです。<br><br>
- [istone-you/memo-app-mern-stack](https://github.com/istone-you/memo-app-mern-stack)はMERN(MongoDB,Express.js,React.js,Node.js)を使用したフルスタックなアプリで、フロントエンドもバックエンドも一つのレポジトリで管理しているため、CodeBuildを二つ利用してフロントはS3にデプロイ、バックエンドはECSにデプロイします。<br><br>
- FireLensとOpenTelemetryのイメージは別途用意したものを使用して、バックエンドのコンテナを監視します。<br><br>

- MongoDBはMongoDB Atlasに構築します。

- ALBは今後実装予定です。
