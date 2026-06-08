# Jenkins + DefectDojo

This repo now runs Jenkins and DefectDojo in one Docker Compose stack and includes a Jenkins pipeline example that uploads a Trivy report to DefectDojo.

## Start the stack

1. Copy `.env.defectdojo.example` to `.env.defectdojo` and replace the default secrets.
2. Start everything:

```bash
docker compose --env-file .env.defectdojo up -d --build
```

3. Open:

- Jenkins: `http://localhost:8080`
- DefectDojo: `http://localhost:8081`

## DefectDojo bootstrap

- Default admin user comes from `.env.defectdojo`.
- The initializer runs automatically on first startup.
- If startup takes a while, watch it with:

```bash
docker compose logs -f defectdojo-initializer
```

## Jenkins pipeline setup

1. Create a DefectDojo API token in DefectDojo from `User menu -> API v2 Key`.
2. In Jenkins, add a `Secret text` credential with ID `defectdojo-api-token`.
3. Create a pipeline job and use `Jenkinsfile.defectdojo`.

The sample pipeline:

- runs `trivy fs` against the Jenkins workspace
- saves the report to `reports/trivy.json`
- uploads it to `POST /api/v2/reimport-scan/`
- auto-creates Product Type, Product, and Engagement if they do not exist

## Notes

- Jenkins uploads to `http://defectdojo-nginx:8080`, which is the internal Compose service address.
- The host uses port `8081` for DefectDojo because Jenkins already uses `8080`.
- `reimport-scan` is used so repeated pipeline runs update the same scan history instead of always creating a new test lineage.
